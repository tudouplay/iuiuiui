class EdgeOneEnv {
  // 环境检测
  static const bool isEdgeOne = bool.fromEnvironment('EDGEONE_DEPLOY', defaultValue: false);
  
  // EdgeOne 优化配置
  static Map<String, dynamic> get config {
    return {
      'corsProxy': isEdgeOne 
          ? 'https://api.allorigins.win/raw?url='  // EdgeOne 优化的代理
          : 'https://corsproxy.io/?',
      'timeout': isEdgeOne ? 30 : 20,
      'retryCount': isEdgeOne ? 2 : 1,
    };
  }
  
  // EdgeOne 专用的资源站配置
  static List<String> get stableResourceSites {
    return [
      'http://caiji.dyttzyapi.com/api.php/provide/vod',  // 电影天堂
      'http://ffzy5.tv/api.php/provide/vod',             // 非凡影视
      'https://jszyapi.com/api.php/provide/vod',         // 极速资源
    ];
  }
  
  // 性能优化配置
  static Map<String, dynamic> get performance {
    return {
      'imageCache': true,
      'preloadPages': isEdgeOne ? 2 : 1,
      'lazyLoad': true,
    };
  }
}