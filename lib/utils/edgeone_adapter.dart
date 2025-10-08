import 'dart:html' as html;

class EdgeOneAdapter {
  /// 初始化 EdgeOne 适配器
  static void initialize() {
    _setupSPARouting();
    _setupErrorHandling();
  }
  
  /// 设置 SPA 路由
  static void _setupSPARouting() {
    // 确保所有路由都指向根路径
    final currentPath = html.window.location.pathname;
    if (currentPath != '/' && !currentPath.startsWith('/#/')) {
      html.window.history.replaceState({}, '', '/');
    }
  }
  
  /// 设置错误处理
  static void _setupErrorHandling() {
    html.window.addEventListener('error', (event) {
      print('EdgeOne 错误: $event');
    });
    
    html.window.addEventListener('unhandledrejection', (event) {
      print('EdgeOne Promise 拒绝: $event');
    });
  }
  
  /// 获取 EdgeOne 优化的 CORS 代理
  static String getCorsProxy(String url) {
    // 使用 CORS 代理服务
    return 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
  }
  
  /// 检查是否是 EdgeOne 环境
  static bool get isEdgeOneEnvironment {
    final hostname = html.window.location.hostname;
    return hostname.contains('edgeone') || hostname.contains('tencent');
  }
}