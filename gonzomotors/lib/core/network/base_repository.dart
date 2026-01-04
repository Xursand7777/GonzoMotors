import 'package:dio/dio.dart';
import '../../main.dart';
import '../log/talker_logger.dart';
import '../storage/flutter_storage.dart';
import 'models/api_response.dart';
import 'models/pagination.dart';


abstract class BaseRepository {
  final Dio dio;


  BaseRepository(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await AuthStorage.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            logger.warning('Ошибка при получении токена: $e');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            logger.warning('Неавторизован: ${e.requestOptions.path}');
            AuthStorage.clear();

            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/phone-register',
                  (route) => false,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }




  Future<ApiResponse<T>> get<T>(
      String path, {
        required T Function(Map<String, dynamic>) fromJson,
        Map<String, dynamic>? queryParameters,
      }) async {
    final res = await dio.get(path, queryParameters: queryParameters);
    return ApiResponse<T>.fromJson(res.data, (data) => fromJson(data));
  }

  Future<ApiResponse<List<T>>> getList<T>(
      String path, {
        required T Function(Map<String, dynamic>) fromJson,
        Map<String, dynamic>? queryParameters,
      }) async {
    final res = await dio.get(path, queryParameters: queryParameters);
    if (res.data["data"] is! List) {
      logger.error("Api response for $path is not a list");
      throw Exception("Api response for $path is not a list");
    }
    return ApiResponse<List<T>>.fromJson(res.data, (data) => data.map<T>((e) => fromJson(e)).toList());
  }

  Future<ApiResponse<List<String>>> getListString(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    final res = await dio.get(path, queryParameters: queryParameters);
    if (res.data["data"] is! List) {
      logger.error("Api response for $path is not a list");
      throw Exception("Api response for $path is not a list");
    }
    return ApiResponse<List<String>>.fromJson(res.data, (data) => List<String>.from(data));
  }

  Future<ApiResponse<Pagination<T>>> getListWithPagination<T>(
      String path, {
        required T Function(Map<String, dynamic>) fromJson,
        Map<String, dynamic>? queryParameters,
      }) async {
    final res = await dio.get(path, queryParameters: queryParameters);
    return ApiResponse<Pagination<T>>.fromJson(res.data, (data) => Pagination<T>.fromJson(data, fromJson));
  }

  Future<Pagination<T>> getListWithPaginationRequest<T>(
      String path, {
        required T Function(Map<String, dynamic>) fromJson,
        Map<String, dynamic>? queryParameters,
      }) async {
    final res = await dio.get(path, queryParameters: queryParameters);


    return Pagination<T>.fromJson(
      res.data as Map<String, dynamic>,
      fromJson,
    );
  }




  Future<ApiResponse<T>> post<T>(
      String path, {
        required T Function(dynamic) fromJson,
        dynamic data,
        Map<String,dynamic>? headers
      }) async {
    if(headers !=null  && headers.isNotEmpty){
      dio.options.headers.addAll(headers);
    }

    final res = await dio.post(path, data: data);
    return ApiResponse<T>.fromJson(res.data, fromJson);
  }

  Future<void> postNoContent(
      String path, {
        dynamic data,
        Map<String, dynamic>? headers,
      }) async {

    if(headers != null && headers.isNotEmpty){
      dio.options.headers.addAll(headers);
    }
    await dio.post(path, data: data);
  }

  Future<ApiResponse> delete(
      String path, {
        dynamic data,
      }) async {
    final res = await dio.delete(path, data: data);
    return ApiResponse.fromJson(res.data, (data) => data);
  }

  Future<ApiResponse<T>> put<T>(
      String path, {
        required T Function(dynamic) fromJson,
        dynamic data,
        Map<String,dynamic>? headers
      }) async {
    if(headers != null  && headers.isNotEmpty){
      dio.options.headers.addAll(headers);
    }

    final res = await dio.put(path, data: data);
    return ApiResponse<T>.fromJson(res.data, fromJson);
  }




}