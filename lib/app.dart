import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/route_generator.dart';
import 'routes/app_routes.dart';
import 'presentation/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hari Ini Masak Apa?',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const SplashScreen(),
    );
  }
}
