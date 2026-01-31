

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import '../../features/auth/data/models/verify_model.dart';
import '../di/app_injection.dart';
import '../log/talker_logger.dart';
import '../services/device_info_service.dart';
import '../services/fcm_service.dart';
import '../services/token_service.dart';

class DioClient {
  final Dio dio;

  DioClient(
      {
        required TokenService tokenService,
        required FcmService fcmService,
        required DeviceInfoService deviceInfoService,
      }
      )
      : dio = Dio(
    BaseOptions(
      baseUrl: 'http://zachir.uz/api/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  ) {
    dio.interceptors.addAll([
      ApiResponseInterceptor(dio, tokenService, fcmService, deviceInfoService),
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
    ]);
  }
}

class ApiResponseInterceptor extends Interceptor {
  final TokenService _tokenService;
  final FcmService _fcmService;
  final DeviceInfoService _deviceInfoService;
  final Dio _dio;
  bool _isRefreshing = false;

  ApiResponseInterceptor(
      this._dio, this._tokenService, this._fcmService, this._deviceInfoService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _tokenService.getToken();
      final fcmToken = await _fcmService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        options.headers['fcm-token'] = fcmToken;
      }
      final deviceId = _deviceInfoService.getDeviceId();
      if (deviceId != null && deviceId.isNotEmpty) {
        options.headers['device-id'] = deviceId;
      }

      final name = _deviceInfoService.getName();
      if (name != null && name.isNotEmpty) {
        options.headers['name'] = name;
      }
      final model = _deviceInfoService.getModel();
      if (model != null && model.isNotEmpty) {
        options.headers['model'] = model;
      }
    } catch (e, stackTrace) {
      log('Error getting token: $e', name: 'DioInterceptor');
      log('StackTrace: $stackTrace', name: 'DioInterceptor');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 xatolik - Token muammosi
    if (err.response?.statusCode == 401) {
      // Agar token allaqachon yangilanayotgan bo'lsa, kutish
      if (_isRefreshing) {
        return super.onError(err, handler);
      }

      // Refresh endpoint uchun loop oldini olish
      if (err.requestOptions.path.contains('auth/refresh')) {
        _isRefreshing = false;
        return super.onError(err, handler);
      }

      _isRefreshing = true;

      try {
        final refreshToken = await _tokenService.getRefreshToken();

        if (refreshToken == null || refreshToken.isEmpty) {
          _isRefreshing = false;
          return super.onError(err, handler);
        }

        final refreshQuery = {
          'refresh_token': refreshToken,
        };

        // Refresh so'rovini interceptorsiz yuborish
        final refreshDio = Dio(BaseOptions(
          baseUrl: 'http://zachir.uz/api/',
        ));

        final refresh =
        await refreshDio.post('auth/refresh', data: refreshQuery);

        if (refresh.statusCode == 200 &&
            refresh.data != null &&
            refresh.data['data'] != null) {
          final VerifyModel verifyModel =
          VerifyModel.fromJson(refresh.data['data']);

          if (verifyModel.accessToken != null &&
              verifyModel.refreshToken != null) {
            await _tokenService.saveToken(verifyModel.accessToken!);
            await _tokenService.saveRefreshToken(verifyModel.refreshToken!);

            // Original so'rovni yangi token bilan qayta yuborish
            final opts = err.requestOptions;
            opts.headers['Authorization'] =
            'Bearer ${verifyModel.accessToken!}';

            try {
              final cloneReq = await _dio.fetch(opts);
              _isRefreshing = false;
              return handler.resolve(cloneReq);
            } on DioException catch (e) {
              _isRefreshing = false;
              return handler.reject(e);
            }
          }
        }
      } catch (e, stackTrace) {
        log('Refresh error: $e', name: 'DioInterceptor');
        log('StackTrace: $stackTrace', name: 'DioInterceptor');
      } finally {
        _isRefreshing = false;
      }
    }

    // 403 Forbidden
    if (err.response?.statusCode == 403) {
      log('403 FORBIDDEN - Access denied', name: 'DioInterceptor');
    }

    // Error ma'lumotlarini log qilish
    if (err.response?.data != null) {
      log('Error Response: ${err.response?.data}', name: 'DioInterceptor');
    }

    //logger.error('API Error: ${err.response?.statusCode} ${err.message}');

    super.onError(err, handler);
  }
}
