import 'package:flutter/material.dart';
import 'package:todo_app/app/app.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
 await getIt<CacheHelper>().init();
  runApp(const MyApp());
}
