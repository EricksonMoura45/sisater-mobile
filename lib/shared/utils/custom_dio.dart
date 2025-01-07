import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:sisater_mobile/shared/utils/app_interceptors.dart';

class CustomDio {
  Dio dio = Dio();

  CustomDio() {
    dio = Dio(
      BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          baseUrl: EnvironmentFlavor().baseURL,
          followRedirects: true),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };

    dio.interceptors.add(Appinterceptors());
  }
}