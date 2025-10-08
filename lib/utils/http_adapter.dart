import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpAdapter {
  static const bool _useCorsProxy = true;
  static const String _corsProxy = 'https://cors-anywhere.herokuapp.com/';
  
  static Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      final Uri uri = Uri.parse(_processUrl(url));
      final response = await http.get(uri, headers: headers);
      
      // 处理 CORS 错误
      if (response.statusCode == 403 || response.statusCode == 0) {
        throw Exception('CORS 错误: 无法访问资源');
      }
      
      return response;
    } catch (e) {
      throw Exception('网络请求失败: $e');
    }
  }
  
  static String _processUrl(String url) {
    if (_useCorsProxy && _needsCorsProxy(url)) {
      return '$_corsProxy$url';
    }
    return url;
  }
  
  static bool _needsCorsProxy(String url) {
    // 为外部 API 添加 CORS 代理
    final needsProxy = [
      'dyttzyapi.com',
      'rycjapi.com',
      'tyyszy.com',
      'ffzy5.tv',
      '360zy.com',
      'maotaizy.cc',
      'jszyapi.com',
      'dbzy.tv',
      'mozhuazy.com',
      'apiyhzy.com',
      'lziapi.com'
    ];
    
    return needsProxy.any((domain) => url.contains(domain));
  }
}