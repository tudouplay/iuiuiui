// services/edgeone_resource_service.dart
import '../config/edgeone_env.dart';

class EdgeOneResourceService {
  // 使用稳定的资源站列表
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final List<Movie> results = [];
    
    for (final site in EdgeOneEnv.stableResourceSites) {
      try {
        final movies = await _fetchFromSite(site, query, page);
        results.addAll(movies);
        
        // 如果已有足够结果，提前返回
        if (results.length >= 8) break;
      } catch (e) {
        print('⚠️ EdgeOne 资源站访问失败: $site - $e');
        // 继续尝试下一个站点
        continue;
      }
    }
    
    return results;
  }
  
  Future<List<Movie>> _fetchFromSite(String site, String query, int page) async {
    final url = '$site?wd=${Uri.encodeComponent(query)}&ac=detail&pg=$page';
    final proxyUrl = '${EdgeOneEnv.config['corsProxy']}$url';
    
    final response = await http.get(
      Uri.parse(proxyUrl),
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; MoonTV-EdgeOne/1.0)',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: EdgeOneEnv.config['timeout']));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ResourceResponse.fromJson(jsonData).list;
    }
    
    throw Exception('HTTP ${response.statusCode}');
  }
}