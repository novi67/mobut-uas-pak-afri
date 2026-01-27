import 'package:dio/dio.dart';

class Api {
  static const String baseUrl = "https://novi.bersama.cloud/api-novi/";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Accept": "application/json"},
      followRedirects: true,
      maxRedirects: 5,
      validateStatus: (s) => s != null && s < 500,
    ),
  );
}
