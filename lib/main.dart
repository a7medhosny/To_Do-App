import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/app.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await getIt<CacheHelper>().init();
  runApp(BlocProvider(
    create: (context) => getIt<TaskCubit>()..getTasks(DateTime.now())..getTheme(),
    child: const MyApp(),
  ));
}
