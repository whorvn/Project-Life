class AppConfig {
  static const String appName = "Hackathon Platform";
  static const String appVersion = "1.0.0";
  static const String apiBaseUrl = "http://localhost:8000";
  
  // API Endpoints
  static const String loginEndpoint = "/api/auth/login";
  static const String registerEndpoint = "/api/auth/register";
  static const String hackathonsEndpoint = "/api/hackathons";
  
  // App Settings
  static const int requestTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  
  // UI Settings
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 4.0;
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 450;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;
}
