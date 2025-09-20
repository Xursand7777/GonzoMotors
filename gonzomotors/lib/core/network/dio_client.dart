import 'package:dio/dio.dart';
import '../log/talker_logger.dart';
import 'models/api_response.dart';
import 'models/pagination.dart';


abstract class BaseRepository {
  final Dio dio;
  BaseRepository(this.dio);

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



  Future<ApiResponse<T>> post<T>(
      String path, {
        required T Function(dynamic) fromJson,
        dynamic data,
      }) async {
    final res = await dio.post(path, data: data);
    return ApiResponse<T>.fromJson(res.data, fromJson);
  }
  Future<void> postNoContent(
      String path, {
        dynamic data,
      }) async {
    await dio.post(path, data: data);
  }



// Istasang: put, delete ham qo‘shish mumkin
}