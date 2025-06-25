import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/create_hackathon_screen.dart';
import '../screens/landing_page_preview_screen.dart';
import '../screens/not_implemented_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
      case '/hackathon/create':
        return MaterialPageRoute(builder: (_) => const CreateHackathonScreen());
      
      case '/hackathon/landing-page-preview':
        return MaterialPageRoute(
          builder: (_) => const LandingPagePreviewScreen(),
          settings: settings,
        );
      
      case '/hackathons/my':
      case '/hackathons/all':
      case '/hackathon/detail':
      case '/hackathon/edit':
      case '/hackathon/landing-page':
      case '/not-implemented':
        return MaterialPageRoute(
          builder: (_) => const NotImplementedScreen(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const NotImplementedScreen(),
          settings: settings,
        );
    }
  }
}
