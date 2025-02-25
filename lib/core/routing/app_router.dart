import 'package:flutter/material.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/features/auth/presention/screens/on_boarding_screen.dart';
import 'package:todo_app/features/auth/presention/screens/splash_screen.dart';
import 'package:todo_app/features/home/presention/screens/add_task_screen.dart';
import 'package:todo_app/features/home/presention/screens/home_screen.dart';

abstract class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (_) => Homescreen());
      case Routes.addTaskScreen:
        return MaterialPageRoute(
            builder: (_) => AddTaskScreen());
    }
    return null;
  }
}
