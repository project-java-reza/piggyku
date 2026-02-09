import 'package:dio/dio.dart';
import 'package:finai_frontend/core/constants/app_constants.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late final Dio _dio;
  final Logger _logger = Logger();

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.connectTimeout),
        receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
        sendTimeout: Duration(seconds: AppConstants.sendTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => _logger.d(obj),
      ),
    );
  }

  // Get Dio instance
  Dio get dio => _dio;

  // Mock data generator for offline mode
  dynamic _getMockResponse(String path, dynamic data) {
    _logger.i('Generating mock response for path: $path');

    if (path.contains('/auth/login')) {
      final loginData = data as Map<String, dynamic>?;
      final email = loginData?['email'] as String? ?? 'user@example.com';

      return {
        'message': 'Login successful (Mock Mode)',
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 1,
          'name': 'Test User',
          'email': email,
          'email_verified_at': '2023-01-01T00:00:00.000000Z',
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        }
      };
    }

    if (path.contains('/auth/register')) {
      final registerData = data as Map<String, dynamic>?;
      final name = registerData?['name'] as String? ?? 'Test User';
      final email = registerData?['email'] as String? ?? 'user@example.com';

      return {
        'message': 'Registration successful (Mock Mode)',
        'user': {
          'id': 2,
          'name': name,
          'email': email,
          'email_verified_at': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        }
      };
    }

    if (path.contains('/auth/me') || path.contains('/user')) {
      return {
        'user': {
          'id': 1,
          'name': 'Test User',
          'email': 'user@example.com',
          'email_verified_at': '2023-01-01T00:00:00.000000Z',
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        }
      };
    }

    if (path.contains('/auth/logout')) {
      return {
        'message': 'Logout successful (Mock Mode)'
      };
    }

    // Transaction statistics endpoint for dashboard (must come before /transactions check)
    if (path.contains('/transactions-statistics')) {
      return _getDummyTransactionStatistics();
    }

    // Default mock responses for other endpoints
    if (path.contains('/transactions')) {
      return _getDummyTransactions();
    }

    if (path.contains('/accounts')) {
      return _getDummyAccounts();
    }

    if (path.contains('/categories')) {
      return _getDummyCategories();
    }

    // Dashboard endpoint (if used directly)
    if (path.contains('/dashboard')) {
      return _getDummyDashboard();
    }

    // Generic mock response
    return {
      'message': 'Request processed successfully (Mock Mode)',
      'data': null,
    };
  }

  // Request interceptor - Add auth token
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessTokenKey);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.i('Added auth token to request: ${options.path}');
      }
    } catch (e) {
      _logger.e('Error adding auth token: $e');
    }

    handler.next(options);
  }

  // Response interceptor
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      'Response [${response.statusCode}] from ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  // Error interceptor
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.e(
      'Error [${err.response?.statusCode}] from ${err.requestOptions.path}',
    );

    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      _logger.w('Unauthorized - Clearing token');
      await _clearAuthData();
    }

    handler.next(err);
  }

  // Clear auth data
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.accessTokenKey);
      await prefs.remove(AppConstants.userDataKey);
    } catch (e) {
      _logger.e('Error clearing auth data: $e');
    }
  }

  // Save auth token
  Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.accessTokenKey, token);
      _logger.i('Auth token saved successfully');
    } catch (e) {
      _logger.e('Error saving auth token: $e');
      rethrow;
    }
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.accessTokenKey);
    } catch (e) {
      _logger.e('Error getting auth token: $e');
      return null;
    }
  }

  // Clear auth token
  Future<void> clearAuthToken() async {
    await _clearAuthData();
  }

  // Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!AppConstants.isBackendEnabled) {
      _logger.i('Backend is disabled - returning mock response for GET: $path');

      // Get mock response data
      final mockData = _getMockResponse(path, null);

      _logger.i('Mock response data type: ${mockData.runtimeType} for path: $path');
      _logger.i('Expected type T: $T');

      // Create mock response object
      return Response<T>(
        data: mockData,
        statusCode: 200,
        requestOptions: RequestOptions(
          path: path,
          method: 'GET',
          queryParameters: queryParameters,
          headers: options?.headers,
        ),
      );
    }

    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!AppConstants.isBackendEnabled) {
      _logger.i('Backend is disabled - returning mock response for POST: $path');

      // Get mock response data
      final mockData = _getMockResponse(path, data);

      // Auto-save token for login endpoint
      if (path.contains('/auth/login') && mockData['token'] != null) {
        await saveAuthToken(mockData['token'] as String);
        _logger.i('Mock authentication token saved automatically');
      }

      // Create mock response object
      return Response<T>(
        data: mockData as T,
        statusCode: 200,
        requestOptions: RequestOptions(
          path: path,
          method: 'POST',
          data: data,
          queryParameters: queryParameters,
          headers: options?.headers,
        ),
      );
    }

    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!AppConstants.isBackendEnabled) {
      _logger.i('Backend is disabled - returning mock response for PUT: $path');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        message: 'Backend is disabled - running in offline mode',
      );
    }

    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!AppConstants.isBackendEnabled) {
      _logger.i('Backend is disabled - returning mock response for DELETE: $path');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        message: 'Backend is disabled - running in offline mode',
      );
    }

    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Dummy Data Methods

  Map<String, dynamic> _getDummyAccounts() {
    return {
      'data': [
        {
          'id': 1,
          'user_id': 1,
          'name': 'Tunai',
          'type': AppConstants.accountTypeCash,
          'starting_balance': '500000',
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        },
        {
          'id': 2,
          'user_id': 1,
          'name': 'BCA',
          'type': AppConstants.accountTypeBank,
          'starting_balance': '2500000',
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        },
        {
          'id': 3,
          'user_id': 1,
          'name': 'Mandiri',
          'type': AppConstants.accountTypeBank,
          'starting_balance': '1500000',
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        },
        {
          'id': 4,
          'user_id': 1,
          'name': 'GoPay',
          'type': AppConstants.accountTypeEwallet,
          'starting_balance': '300000',
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        },
        {
          'id': 5,
          'user_id': 1,
          'name': 'OVO',
          'type': AppConstants.accountTypeEwallet,
          'starting_balance': '250000',
          'is_active': true,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
        },
      ],
      'meta': {
        'total': 5,
        'filters_applied': {
          'search': null,
          'is_active': null,
        },
      },
    };
  }

  Map<String, dynamic> _getDummyCategories() {
    return {
      'data': [
        // Income Categories
        {
          'id': 1,
          'user_id': 1,
          'name': 'Gaji',
          'type': AppConstants.transactionTypeIncome,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 2,
          'user_id': 1,
          'name': 'Bonus',
          'type': AppConstants.transactionTypeIncome,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 3,
          'user_id': 1,
          'name': 'Usaha',
          'type': AppConstants.transactionTypeIncome,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 4,
          'user_id': 1,
          'name': 'Investasi',
          'type': AppConstants.transactionTypeIncome,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },

        // Expense Categories
        {
          'id': 5,
          'user_id': 1,
          'name': 'Makanan',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 6,
          'user_id': 1,
          'name': 'Transportasi',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 7,
          'user_id': 1,
          'name': 'Belanja',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 8,
          'user_id': 1,
          'name': 'Tagihan',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 9,
          'user_id': 1,
          'name': 'Hiburan',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
        {
          'id': 10,
          'user_id': 1,
          'name': 'Kesehatan',
          'type': AppConstants.transactionTypeExpense,
          'parent_id': null,
          'created_at': '2023-01-01T00:00:00.000000Z',
          'updated_at': '2023-01-01T00:00:00.000000Z',
          'parent': null,
          'children': [],
        },
      ],
      'current_page': 1,
      'last_page': 1,
      'per_page': 15,
      'total': 10,
      'message': 'Categories fetched successfully (Mock Mode)',
    };
  }

  Map<String, dynamic> _getDummyTransactions() {
    final now = DateTime.now();
    final transactions = [
      // Recent transactions (last 7 days)
      {
        'id': 1,
        'user_id': 1,
        'account_id': 1, // Tunai
        'category_id': 1, // Gaji
        'type': AppConstants.transactionTypeIncome,
        'date': now.subtract(Duration(days: 1)).toIso8601String().split('T')[0],
        'amount': '8000000',
        'note': 'Gaji bulanan November',
        'counterparty': 'PT. Tech Indonesia',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'account': {'id': 1, 'name': 'Tunai', 'type': AppConstants.accountTypeCash},
        'category': {'id': 1, 'name': 'Gaji', 'type': AppConstants.transactionTypeIncome},
      },
      {
        'id': 2,
        'user_id': 1,
        'account_id': 2, // BCA
        'category_id': 5, // Makanan
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 2)).toIso8601String().split('T')[0],
        'amount': '150000',
        'note': 'Makan siang kantor',
        'counterparty': 'Restoran Padang Sederhana',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 2)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 2)).toIso8601String(),
        'account': {'id': 2, 'name': 'BCA', 'type': AppConstants.accountTypeBank},
        'category': {'id': 5, 'name': 'Makanan', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 3,
        'user_id': 1,
        'account_id': 4, // GoPay
        'category_id': 6, // Transportasi
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 3)).toIso8601String().split('T')[0],
        'amount': '45000',
        'note': 'Gojek ke kantor',
        'counterparty': 'Gojek',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 3)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 3)).toIso8601String(),
        'account': {'id': 4, 'name': 'GoPay', 'type': AppConstants.accountTypeEwallet},
        'category': {'id': 6, 'name': 'Transportasi', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 4,
        'user_id': 1,
        'account_id': 3, // Mandiri
        'category_id': 8, // Tagihan
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 4)).toIso8601String().split('T')[0],
        'amount': '1250000',
        'note': 'Listrik bulanan',
        'counterparty': 'PLN',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 4)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 4)).toIso8601String(),
        'account': {'id': 3, 'name': 'Mandiri', 'type': AppConstants.accountTypeBank},
        'category': {'id': 8, 'name': 'Tagihan', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 5,
        'user_id': 1,
        'account_id': 1, // Tunai
        'category_id': 7, // Belanja
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 5)).toIso8601String().split('T')[0],
        'amount': '250000',
        'note': 'Belanja kebutuhan dapur',
        'counterparty': 'Superindo',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 5)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 5)).toIso8601String(),
        'account': {'id': 1, 'name': 'Tunai', 'type': AppConstants.accountTypeCash},
        'category': {'id': 7, 'name': 'Belanja', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 6,
        'user_id': 1,
        'account_id': 2, // BCA
        'category_id': 9, // Hiburan
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 6)).toIso8601String().split('T')[0],
        'amount': '120000',
        'note': 'Nonton bioskop',
        'counterparty': 'XXI Cinema',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 6)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 6)).toIso8601String(),
        'account': {'id': 2, 'name': 'BCA', 'type': AppConstants.accountTypeBank},
        'category': {'id': 9, 'name': 'Hiburan', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 7,
        'user_id': 1,
        'account_id': 3, // Mandiri
        'category_id': 2, // Bonus
        'type': AppConstants.transactionTypeIncome,
        'date': now.subtract(Duration(days: 7)).toIso8601String().split('T')[0],
        'amount': '2000000',
        'note': 'Bonus proyek',
        'counterparty': 'PT. Tech Indonesia',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 7)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 7)).toIso8601String(),
        'account': {'id': 3, 'name': 'Mandiri', 'type': AppConstants.accountTypeBank},
        'category': {'id': 2, 'name': 'Bonus', 'type': AppConstants.transactionTypeIncome},
      },
      {
        'id': 8,
        'user_id': 1,
        'account_id': 4, // GoPay
        'category_id': 10, // Kesehatan
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 8)).toIso8601String().split('T')[0],
        'amount': '85000',
        'note': 'Obat dan vitamin',
        'counterparty': 'K24 Apotek',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 8)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 8)).toIso8601String(),
        'account': {'id': 4, 'name': 'GoPay', 'type': AppConstants.accountTypeEwallet},
        'category': {'id': 10, 'name': 'Kesehatan', 'type': AppConstants.transactionTypeExpense},
      },
    ];

    return {
      'message': 'Transactions fetched successfully (Mock Mode)',
      'data': transactions,
      'pagination': {
        'current_page': 1,
        'last_page': 1,
        'per_page': 15,
        'total': transactions.length,
        'from': 1,
        'to': transactions.length,
      },
    };
  }

  Map<String, dynamic> _getDummyTransactionStatistics() {
    // Calculate totals based on dummy transactions
    final totalIncome = 10000000; // 8M salary + 2M bonus
    final totalExpense = 1865000; // Sum of all expenses
    final netAmount = totalIncome - totalExpense;

    return {
      'message': 'Transaction statistics fetched successfully (Mock Mode)',
      'data': {
        'total_income': totalIncome.toString(),
        'total_expense': totalExpense.toString(),
        'transaction_count': 8,
        'income_count': 2,
        'expense_count': 6,
        'net_amount': netAmount.toString(),
      }
    };
  }

  Map<String, dynamic> _getDummyDashboard() {
    final now = DateTime.now();
    final recentTransactions = [
      {
        'id': 1,
        'user_id': 1,
        'account_id': 1,
        'category_id': 1,
        'type': AppConstants.transactionTypeIncome,
        'date': now.subtract(Duration(days: 1)).toIso8601String().split('T')[0],
        'amount': '8000000',
        'note': 'Gaji bulanan November',
        'counterparty': 'PT. Tech Indonesia',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'account': {'id': 1, 'name': 'Tunai', 'type': AppConstants.accountTypeCash},
        'category': {'id': 1, 'name': 'Gaji', 'type': AppConstants.transactionTypeIncome},
      },
      {
        'id': 2,
        'user_id': 1,
        'account_id': 2,
        'category_id': 5,
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 2)).toIso8601String().split('T')[0],
        'amount': '150000',
        'note': 'Makan siang kantor',
        'counterparty': 'Restoran Padang Sederhana',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 2)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 2)).toIso8601String(),
        'account': {'id': 2, 'name': 'BCA', 'type': AppConstants.accountTypeBank},
        'category': {'id': 5, 'name': 'Makanan', 'type': AppConstants.transactionTypeExpense},
      },
      {
        'id': 3,
        'user_id': 1,
        'account_id': 4,
        'category_id': 6,
        'type': AppConstants.transactionTypeExpense,
        'date': now.subtract(Duration(days: 3)).toIso8601String().split('T')[0],
        'amount': '45000',
        'note': 'Gojek ke kantor',
        'counterparty': 'Gojek',
        'transfer_group_id': null,
        'created_at': now.subtract(Duration(days: 3)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 3)).toIso8601String(),
        'account': {'id': 4, 'name': 'GoPay', 'type': AppConstants.accountTypeEwallet},
        'category': {'id': 6, 'name': 'Transportasi', 'type': AppConstants.transactionTypeExpense},
      },
    ];

    return {
      'recent_transactions': recentTransactions,
      'accounts_count': 5,
      'categories_count': 10,
      'transactions_count': 8,
      'message': 'Dashboard data fetched successfully (Mock Mode)',
    };
  }
}
