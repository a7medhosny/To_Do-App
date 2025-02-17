import 'package:flutter/material.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/features/auth/presention/screens/splash_screen.dart';

abstract class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
    return null;
  }
}
