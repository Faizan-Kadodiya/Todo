import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/theme/native_theme.dart';
import 'package:todo/utils/binding/controller_binding.dart';
import 'package:get/get.dart';
import 'package:todo/controllers/theme_controller.dart';
import 'package:todo/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeAndLanguageController());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeAndLanguageController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'Todo',
          navigatorKey: Get.key,
          enableLog: true,
          initialBinding: ControllerBinding(),
          theme: nativeTheme(),
          debugShowCheckedModeBanner: false,
          initialRoute: "SplashScreen",
          home: SplashScreen(),
        );
      },
    );
  }
}
