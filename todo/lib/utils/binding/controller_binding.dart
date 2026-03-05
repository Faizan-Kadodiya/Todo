//packages

import 'package:get/get.dart';
import 'package:todo/controllers/home_controller.dart';
import 'package:todo/controllers/splash_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
