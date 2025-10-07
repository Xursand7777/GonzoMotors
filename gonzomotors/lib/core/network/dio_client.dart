

import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import '../log/talker_logger.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'http://zachir.uz/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  ) {
    // Optional: Interceptor qo‘shish
    dio.interceptors.addAll([
      TalkerDioLogger(
          talker: logger,
          settings: const TalkerDioLoggerSettings(
            printResponseTime: false,
            printRequestData: true,
            printResponseData :true,
            printResponseHeaders :false,
            printResponseMessage :false,
            printResponseRedirects :false,
            printErrorData :false,
            printErrorHeaders :false,
            printErrorMessage :false,
            printRequestHeaders :false,
            printRequestExtra :false,
          )),
      // ApiResponseInterceptor(parsers)
    ]);
  }
}