import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/routing/app_router.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/app_strings.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return MaterialApp(
          title: AppStrings.appName,
          theme: getAppTheme(),
          darkTheme: getAppDarkTheme(),
          themeMode: BlocProvider.of<TaskCubit>(context).isDark
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: Routes.splashScreen,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
