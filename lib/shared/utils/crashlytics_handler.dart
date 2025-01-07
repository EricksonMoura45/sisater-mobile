import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
class CrashlyticsHandler {
  static void reportException(
    Object e, {
    StackTrace? stackTrace,
    String key = 'Exception',
    String value = 'app',
  }) {
    developer.log('reportException: $e');

    FirebaseCrashlytics.instance.setCustomKey(key, value);
    Map<String, dynamic> errorLog = {
      'Exception': e.toString(),
      'Usuario': _buildUserLog(),
    };
    FirebaseCrashlytics.instance.recordError(
      errorLog,
      stackTrace,
      printDetails: true,
    );
  }

  static void reportDioError(DioException err) {
    developer.log('reportDioError: $err');

    FirebaseCrashlytics.instance.setCustomKey('DioError', 'app_interceptor');
    Map<String, dynamic> errorLog = {
      'DioError': _buildDioErrorLog(err),
      'Usuario': _buildUserLog(),
    };
    FirebaseCrashlytics.instance.recordError(
      errorLog,
      err.stackTrace,
      printDetails: true,
    );
  }

  static Map _buildUserLog() {
    final AppStore appStore = Modular.get();
    return {
      'loginResponse': '', //appStore.loginResponse?.toFirebaseJson(),
      'clienteSelecionado': '', //appStore.clienteSelecionado?.toJson(),
      'unidadeSelecionada': '', //appStore.unidadeSelecionada?.toJson(),
      'dashboard': '' //appStore.dashboard?.toJson(),
    };
  }

  static Map _buildDioErrorLog(DioException err) {
    err.requestOptions.headers.remove('Authorization');
    if (err.requestOptions.data != null &&
        err.requestOptions.data.runtimeType != String) {
      // Evita que o Firebase receba a senha do cliente.
      (err.requestOptions.data).remove('password');
    }
    Map<String, dynamic> dioErrorLog = {
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
    return dioErrorLog;
  }
}