import 'package:get_it/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';
import 'package:todo_app/core/database/sqflite_helper/sqflite_helper.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';

final getIt = GetIt.instance;
Future<void> setup() async {
    getIt.registerSingleton<SqfLiteHelper>(SqfLiteHelper());
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  getIt.registerSingleton<TaskCubit>(TaskCubit());
}
