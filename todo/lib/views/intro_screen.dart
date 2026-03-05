import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/controllers/intro_controller.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final IntroController introController = Get.find<IntroController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: introController.pageController,
            scrollDirection: Axis.vertical,
            itemCount: introController.pages.length,
            onPageChanged: introController.onPageChanged,
            itemBuilder: (context, index) {
              return Container(
                color: introController.pages[index].color,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<IntroController>(
                      builder: (_) {
                        return SizedBox(
                          width: double.infinity,
                          child: SlideTransition(
                            position: introController.titleAnimation,
                            child: Text(
                              introController.pages[index].title,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: introController.isTitleAnimating
                                    ? AppColor.blackLightColor
                                    : AppColor.whiteColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: SlideTransition(
                        position: introController.subTitleSlideAnimation,
                        child: ScaleTransition(
                          scale: introController.subtitleScaleAnimation,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                introController.pages[index].subtitle,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                introController.pages[index].subtitle2,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: introController.onTapSkip,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "SKIP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
