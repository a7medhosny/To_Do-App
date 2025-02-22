import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/utils/app_assets.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/core/utils/app_strings.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final bool isVisited =
      getIt<CacheHelper>().getData(key: AppStrings.onBoardingKey) ?? false;
  @override
  Widget build(BuildContext context) {
    String initRoute = isVisited ? Routes.homeScreen : Routes.onBoardingScreen;

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, initRoute);
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logo),
            Text(
              AppStrings.appName,
              style: GoogleFonts.lato(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
