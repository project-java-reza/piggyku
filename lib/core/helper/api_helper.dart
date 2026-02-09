import 'package:dio/dio.dart';
import 'package:finai_frontend/core/config/app_config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiHelper {
  late Dio dio;

  ApiHelper() {
    dio = Dio();
    // Ensure environment is properly initialized
    final env = AppConfig.environment;
    dio.options.baseUrl = env.url;
    dio.options.connectTimeout = AppConfig.connectTimeout;
    dio.options.receiveTimeout = AppConfig.receiveTimeout;
    dio.options.responseType = ResponseType.json;
  }

  Future<Response<T>> post<T>(
    String url,
    Object data,
    Map<String, dynamic>? extra,
  ) {
    dio.options.extra = extra ?? {};
    return dio.post(
      url,
      data: data,
    );
  }

  Future<Response<T>> get<T>(
    String url,
    Map<String, dynamic> data,
    Map<String, dynamic>? extra,
  ) {
    dio.options.extra = extra ?? {};
    return dio.get(
      url,
      queryParameters: data,
    );
  }

  Future<Response> download<T>(
      String url, String savingPath, Function(int, int) progress) {
    return dio.download(url, savingPath, onReceiveProgress: progress);
  }
}
