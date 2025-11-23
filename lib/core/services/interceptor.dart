import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:finai_frontend/core/config/app_config.dart';
import 'package:finai_frontend/core/translator/translator.dart';
import 'package:finai_frontend/core/util/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_json/pretty_json.dart';

class AppInterceptors extends InterceptorsWrapper {
  Response? tempResponse;
  PackageInfo? packageInfo;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var lang = 'ind';
    await Prefs.getLanguage.then((value) {
      if (value == 'en') {
        lang = 'eng';
      } else {
        lang = 'ind';
      }
    });
    packageInfo = await PackageInfo.fromPlatform();
    options.headers['Accept-Language'] = lang;
    options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    options.headers['mbrevamp'] = "true";
    options.headers['X-APP-VERSION'] = packageInfo?.version;
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    tempResponse = response;

    Map<String, dynamic> formDataMap = {};
    if (response.requestOptions.data is FormData) {
      if (kDebugMode) {
        try {
          formDataMap
              .addEntries((response.requestOptions.data as FormData).fields);
        } catch (e) {
          print(e);
        }
      }
    }

    if (AppConfig.environment.isDebug) {
      log(
        "========================ON RESPONSE=======================\n"
        "time : ${DateTime.now()}\n"
        "Status Code : ${response.statusCode}\n"
        "Method : ${response.requestOptions.method}\n"
        "---------------------------------------------------------\n"
        "URL : ${response.requestOptions.uri}\n"
        "Headers : ${prettyJson(response.requestOptions.headers)}\n"
        "REQUEST : ${response.requestOptions.data is FormData ? prettyJson(formDataMap) : prettyJson(response.requestOptions.data ?? response.requestOptions.queryParameters ?? '')}\n"
        "RESPONSE : ${response.data is ResponseBody ? response.data : prettyJson(response.data)}\n"
        "===============================================",
      );
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    var error = err.error;
    log('error interceptor : ${err.toString()}');

    try {
      if (AppConfig.environment.isDebug) {
        log("=======================ON ERROR===============================\n"
            "time : ${DateTime.now()}\n"
            "Status Code : ${err.response?.statusCode}\n"
            "Method : ${err.requestOptions.method}\n"
            "URL : ${err.requestOptions.uri}\n"
            "Headers : ${prettyJson(err.requestOptions.headers)}\n"
            "REQUEST : ${err.requestOptions.data is FormData ? prettyJson((err.requestOptions.data as FormData).fields.toList()) : prettyJson(err.requestOptions.data ?? err.requestOptions.queryParameters ?? '')}\n"
            "RESPONSE error : ${err.response is ResponseBody ? (err.response as ResponseBody) : err.response?.data != null ? prettyJson(err.response?.data) : err} \n"
            "===============================================");
      }
      // Firestore.trxErrorAdd(FirestoreTransactionError(
      //   url: err.requestOptions.uri.toString(),
      //   headers: err.requestOptions.headers.toString(),
      //   request:
      //       '${err.requestOptions.data is FormData ? prettyJson((err.requestOptions.data as FormData).fields.toList()) : prettyJson(err.requestOptions.data ?? err.requestOptions.queryParameters ?? '')}\n"',
      //   response:
      //       '${err.response is ResponseBody ? (err.response as ResponseBody) : err.response?.data != null ? prettyJson(err.response?.data) : err} \n"',
      //   errorCode: err.type.name,
      // ));
    } catch (e) {
      debugPrint('error debug trx error : ${e.toString()}');
    }

    debugPrint('err.type : ${err.type}');
    switch (err.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        error = translator.problemConnection;
        break;
      case DioExceptionType.badResponse:
        error = translator.internalServerError;
      default:
        error = translator.problemConnection;
        break;
    }

    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: error,
    ));
  }
}
