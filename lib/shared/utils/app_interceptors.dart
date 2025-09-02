import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'dart:developer' as developer;

import 'package:sisater_mobile/modules/app_store.dart';


class Appinterceptors extends QueuedInterceptor {
  
   final AppStore _appStore = Modular.get();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({'Content-Type': 'application/json'});
    options.headers.addAll({'accept': '*/*'});
    String? token = _appStore.loginResponse?.accessToken;
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    _logOnRequest(options);
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    _logOnError(err);

    // CrashlyticsHandler.reportDioError(err);
    // if (err.response?.statusCode == HttpStatus.unauthorized) {
    //   _appStore.logout();
    // }

    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log('onResponse: $response');
    return handler.next(response);
  }

  void _logOnRequest(RequestOptions options) {
    Map<String, dynamic> requestLog = {
      options.method: '${options.uri}',
      'data': '${options.data}',
      'headers': '${options.headers}'
    };
    developer.log('onRequest: $requestLog');
  }

  void _logOnError(DioException err) {
    Map<String, dynamic> errorLog = {
      'requestOptions.method': err.requestOptions.method,
      'requestOptions.baseUrl': err.requestOptions.baseUrl,
      'response.requestOptions.path': err.response?.requestOptions.path,
      'requestOptions.queryParameters': err.requestOptions.queryParameters,
      'requestOptions.headers': err.requestOptions.headers,
      'response.headers': err.response?.headers,
      'response.data': err.response?.data,
      'response.statusCode': err.response?.statusCode,
      'err.stackTrace': err.stackTrace.toString(),
      'requestOptions.data': err.requestOptions.data
    };
    developer.log('onError: $errorLog');
  }
}