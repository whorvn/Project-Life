class AppConfig {
  static const String appName = 'HackPlatform';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'http://localhost:8000/api';
  
  // API endpoints
  static const String authEndpoint = '/auth';
  static const String hackathonsEndpoint = '/hackathons';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // App settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
