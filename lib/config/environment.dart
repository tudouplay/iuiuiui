class Environment {
  static const String appName = 'MoonTV';
  static const String version = '1.0.0';
  
  // 不同环境的配置
  static const bool isWeb = true;
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  // API 配置
  static const String tmdbApiKey = '3f3a99a9456828a1a834f9e89c1b0236';
  static const String tmdbAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZjNhOTlhOTQ1NjgyOGExYTgzNGY5ZTg5YzFiMDIzNiIsIm5iZiI6MTc1OTkzMjUzOS4wNDQsInN1YiI6IjY4ZTY3MDdiYmJlNWEyNDgxMzc5NTIwOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NFZ1dVPIV3mlsjRsvzcTZtsKBgXuEewgsmHxrFu8Fgk';
  
  // CORS 代理配置
  static String get corsProxy {
    if (isWeb) {
      return 'https://cors-anywhere.herokuapp.com/';
    }
    return '';
  }
  
  // 基础 URL
  static String get baseUrl {
    if (isWeb) {
      return '/';
    }
    return 'http://localhost:8080/';
  }
}