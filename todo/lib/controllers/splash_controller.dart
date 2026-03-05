import 'package:get/get.dart';
import 'package:todo/utils/global.dart' as global;
import 'package:todo/views/intro_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    try {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => IntroScreen());
      });
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "splash_controller.dart",
        functionNameWithoutBraces: "init",
        e: e,
      );
    }
  }
}
