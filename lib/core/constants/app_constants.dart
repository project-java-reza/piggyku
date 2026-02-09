class AppConstants {
  // Backend Configuration - SET TO false TO DISABLE BACKEND CONNECTION
  static const bool isBackendEnabled = false;

  // API Configuration
  static const String baseUrl = isBackendEnabled
      ? 'https://buku.jagoflutter.com/api'
      : 'http://localhost:0000/disabled'; // Disabled backend URL
  static const String apiVersion = 'v1';

  // App Configuration
  static const String appName = 'FinAi App';
  static const String appVersion = '1.0.0';

  // Local Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String getCurrentUserEndpoint = '/auth/me';
  static const String getAuthenticatedUserEndpoint = '/user';

  // Account Endpoints
  static const String accountsEndpoint = '/accounts';
  static String accountDetailsEndpoint(int id) => '/accounts/$id';

  // Category Endpoints
  static const String categoriesEndpoint = '/categories';
  static String categoryDetailsEndpoint(int id) => '/categories/$id';

  // Transaction Endpoints
  static const String transactionsEndpoint = '/transactions';
  static String transactionDetailsEndpoint(int id) => '/transactions/$id';
  static const String transferEndpoint = '/transactions/transfer';
  static const String transactionStatisticsEndpoint = '/transactions-statistics';

  // Report Endpoints
  static const String reportsEndpoint = '/reports';
  static const String dashboardEndpoint = '/dashboard';

  // Pagination
  static const int defaultPageSize = 15;
  static const int maxPageSize = 100;

  // Time Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;

  // Account Types
  static const String accountTypeCash = 'cash';
  static const String accountTypeBank = 'bank';
  static const String accountTypeEwallet = 'ewallet';
  static const String accountTypeOther = 'other';

  // Transaction Types
  static const String transactionTypeIncome = 'income';
  static const String transactionTypeExpense = 'expense';

  // HTTP Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
}
