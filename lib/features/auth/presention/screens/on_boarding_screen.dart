import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/core/utils/app_strings.dart';
import 'package:todo_app/features/auth/data/models/on_boarding_model.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return _pageItem(
                      OnBoardingModel.onBoardingModels[index], index, context);
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageItem(OnBoardingModel onBoardingModel, index, context) {
    return Column(
      children: [
        index != 2
            ? Row(
                children: [
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    },
                    child: Text(
                      AppStrings.skip,
                      style: Theme.of(context).textTheme.displaySmall!
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 50,
              ),

        const SizedBox(
          height: 16,
        ),

        Image.asset(onBoardingModel.imgPath),
        const SizedBox(
          height: 16,
        ),

        //dots
        SmoothPageIndicator(
          controller: controller,
          count: 3,
          effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary, dotHeight: 10, spacing: 8),
        ),
        const SizedBox(
          height: 52,
        ),

        //title
        Text(onBoardingModel.title,
            style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(
          height: 42,
        ),

        //subtitle
        Text(
          onBoardingModel.subTitle,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        //buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.previousPage(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              child: Text(
                AppStrings.back,
                style: Theme.of(context).textTheme.displaySmall!
              ),
            ),
            index != 2
                ? ElevatedButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      AppStrings.next,
                      style: TextStyle(color: AppColors.white),
                    ))
                : ElevatedButton(
                    onPressed: () async {
                      await getIt<CacheHelper>()
                          .saveData(key: AppStrings.onBoardingKey, value: true)
                          .then((val) {
                        Navigator.pushReplacementNamed(
                            context, Routes.homeScreen);
                      });
                    },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      AppStrings.getStarted,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
