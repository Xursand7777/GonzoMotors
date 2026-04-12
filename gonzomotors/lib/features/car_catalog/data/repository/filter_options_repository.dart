import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gonzo_motors/core/network/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/filter_options.dart';

abstract class FilterOptionsRepository extends BaseRepository {
  FilterOptionsRepository(super.dio);
  Future<FilterOptions> getFilterOptions({bool forceRefresh = false});
}

class FilterOptionsRepositoryImpl extends FilterOptionsRepository {
  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'filter_options_cache';

  FilterOptionsRepositoryImpl(super.dio, this.sharedPreferences);

  @override
  Future<FilterOptions> getFilterOptions({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedStr = sharedPreferences.getString(_cacheKey);
      if (cachedStr != null && cachedStr.isNotEmpty) {
        try {
          final jsonMap = jsonDecode(cachedStr) as Map<String, dynamic>;
          return FilterOptions.fromJson(jsonMap);
        } catch (e) {
          // Fallback to fetch if cache is corrupted
        }
      }
    }

    // Fetch from backend
    try {
      final response = await dio.get('/Cars/filter-options');
      if (response.data != null) {
        // Save to cache
        await sharedPreferences.setString(_cacheKey, jsonEncode(response.data));
        return FilterOptions.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      // Return cached if failed to fetch
      final cachedStr = sharedPreferences.getString(_cacheKey);
      if (cachedStr != null && cachedStr.isNotEmpty) {
        final jsonMap = jsonDecode(cachedStr) as Map<String, dynamic>;
        return FilterOptions.fromJson(jsonMap);
      }
      rethrow;
    }

    return const FilterOptions();
  }
}
