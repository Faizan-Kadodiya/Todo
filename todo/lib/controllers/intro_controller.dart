import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/models/intro_model.dart';
import 'package:todo/utils/global.dart' as global;
import 'package:todo/views/home_screen.dart';

class IntroController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<IntroModel> pages = [
    IntroModel(
      color: AppColor.greenColor,
      title: "How much\nof my earnings\ndo I get to keep?",
      subtitle: "100%.",
      subtitle2: "We charge zero commission on your sales.",
    ),
    IntroModel(
      color: AppColor.blueColor,
      title: "Will i get paid\non time,\nand is it safe?",
      subtitle: "Always.",
      subtitle2: "Payments are secure and on-time, every time.",
    ),
    IntroModel(
      color: AppColor.pinkColor,
      title: "Can i reach more\ncustomers beyond\nmy area?",
      subtitle: "Yes!",
      subtitle2: "we deliver to 20,000+ pin codes across India.",
    ),
    IntroModel(
      color: AppColor.orangeColor,
      title: "What if most of my\nsales happen offline?",
      subtitle: "No Worries",
      subtitle2: "offline exposure is part of the plan.",
    ),
    IntroModel(
      color: AppColor.redColor,
      title: "How do I minimize\nreturns and losses?",
      subtitle: "With us,",
      subtitle2: "you get fewer returns and more profit.",
    ),
  ];

  final PageController pageController = PageController();
  late AnimationController animationController;

  late Animation<Offset> titleAnimation;
  late Animation<Offset> subTitleSlideAnimation;
  late Animation<double> subtitleScaleAnimation;

  int currentPage = 0;

  Timer? timer;

  bool _istitleAnimating = false;
  bool _animationCompleted = false;

  bool get isTitleAnimating => _istitleAnimating || _animationCompleted;

  @override
  void onInit() {
    super.onInit();

    init();
  }

  @override
  void onClose() {
    timer?.cancel();
    animationController.stop();
    animationController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void init() {
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      );

      subTitleSlideAnimation =
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(1 / 6, 1 / 3, curve: Curves.easeInOut),
            ),
          );

      subtitleScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(1 / 6, 1 / 3, curve: Curves.easeOut),
        ),
      );

      titleAnimation =
          Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.4)).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(1 / 6, 1 / 3, curve: Curves.easeInOut),
            ),
          );

      animationController.addListener(() {
        double animValue = animationController.value;
        bool isInInterval = animValue >= 1 / 6 && animValue <= 1 / 3;

        if (isInInterval && !_istitleAnimating) {
          // Animation started
          _istitleAnimating = true;
          update();
        } else if (!isInInterval && _istitleAnimating) {
          // Animation ended
          _istitleAnimating = false;
          _animationCompleted = true;
          update();
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        animationController.forward();
      });

      timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (currentPage < pages.length - 1) {
          currentPage++;
        } else {
          currentPage = 0;
          pageController.jumpToPage(0);
        }

        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      });
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "intro_controller",
        functionNameWithoutBraces: "init",
        e: e,
      );
    }
  }

  void onPageChanged(int index) {
    try {
      currentPage = index;

      _animationCompleted = false;

      animationController.reset();
      animationController.forward();

      update();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "intro_controller",
        functionNameWithoutBraces: "onPageChanged",
        e: e,
      );
    }
  }

  void onTapSkip() {
    try {
      Get.offAll(() => HomeScreen());
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "intro_controller",
        functionNameWithoutBraces: "onTapSkip",
        e: e,
      );
    }
  }
}
