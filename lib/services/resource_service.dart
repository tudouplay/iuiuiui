import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/resource_config.dart';
import '../models/movie_model.dart';

class ResourceService {
  static final ResourceService _instance = ResourceService._internal();
  factory ResourceService() => _instance;
  ResourceService._internal();

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    List<Movie> allMovies = [];
    
    for (final site in ResourceConfig.sites.entries) {
      try {
        final movies = await _searchFromSite(site.value, query, page: page);
        allMovies.addAll(movies);
      } catch (e) {
        print('Error searching from ${site.value.name}: $e');
      }
    }
    
    // 去重
    final seenIds = <String>{};
    return allMovies.where((movie) => seenIds.add(movie.vodId)).toList();
  }

  Future<List<Movie>> getHomeMovies({int page = 1}) async {
    List<Movie> allMovies = [];
    
    for (final site in ResourceConfig.sites.entries) {
      try {
        final movies = await _getFromSite(site.value, page: page);
        allMovies.addAll(movies);
      } catch (e) {
        print('Error getting movies from ${site.value.name}: $e');
      }
    }
    
    // 按更新时间排序
    allMovies.sort((a, b) => (b.updateTime ?? '').compareTo(a.updateTime ?? ''));
    
    // 去重
    final seenIds = <String>{};
    return allMovies.where((movie) => seenIds.add(movie.vodId)).toList();
  }

  Future<Movie> getMovieDetail(Movie movie) async {
    for (final site in ResourceConfig.sites.entries) {
      try {
        final detail = await _getDetailFromSite(site.value, movie.vodId);
        if (detail != null) {
          return detail;
        }
      } catch (e) {
        print('Error getting detail from ${site.value.name}: $e');
      }
    }
    throw Exception('无法获取影片详情');
  }

  Future<List<Movie>> _searchFromSite(ResourceSite site, String query, {int page = 1}) async {
    final url = '${site.api}?wd=$query&ac=detail&pg=$page';
    final response = await HttpAdopter.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final resourceResponse = ResourceResponse.fromJson(jsonData);
      return resourceResponse.list;
    }
    throw Exception('请求失败: ${response.statusCode}');
  }

  Future<List<Movie>> _getFromSite(ResourceSite site, {int page = 1}) async {
    final url = '${site.api}?ac=detail&pg=$page';
    final response = await HttpAdopter.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final resourceResponse = ResourceResponse.fromJson(jsonData);
      return resourceResponse.list;
    }
    throw Exception('请求失败: ${response.statusCode}');
  }

  Future<Movie?> _getDetailFromSite(ResourceSite site, String vodId) async {
    final url = '${site.api}?ac=detail&ids=$vodId';
    final response = await HttpAdopter.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final resourceResponse = ResourceResponse.fromJson(jsonData);
      if (resourceResponse.list.isNotEmpty) {
        return _parseMovieWithSources(resourceResponse.list.first);
      }
    }
    return null;
  }

  Movie _parseMovieWithSources(Movie movie) {
    // 解析播放源和剧集信息
    // 这里需要根据实际API返回的数据结构来解析
    // 暂时返回原始数据，后续可以添加具体解析逻辑
    return movie;
  }
}