import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/app_config.dart';
import 'config/theme_config.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/hackathon_provider.dart';
import 'utils/route_generator.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HackathonPlatformApp());
}

class HackathonPlatformApp extends StatelessWidget {
  const HackathonPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ChangeNotifierProvider(create: (_) => HackathonProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppConfig.appName,
                
                // Theme Configuration
                theme: ThemeConfig.lightTheme,
                darkTheme: ThemeConfig.darkTheme,
                themeMode: themeProvider.themeMode,
                
                // Responsive Framework for Web
                builder: (context, child) => ResponsiveBreakpoints.builder(
                  child: child!,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                    const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                  ],
                ),
                
                // Initial Route
                initialRoute: '/',
                home: const SplashScreen(),
                
                // Route Generation
                onGenerateRoute: RouteGenerator.generateRoute,
                
                // Global Navigation Behavior for Web
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  scrollbars: true,
                  physics: const BouncingScrollPhysics(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
