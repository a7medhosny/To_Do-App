import 'package:flutter/material.dart';
import 'package:todo_app/core/routing/app_router.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/app_strings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.tilte,
      theme: AppTheme.getAppTheme(),
initialRoute: Routes.splashScreen,
onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
