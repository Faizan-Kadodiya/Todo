import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:todo/utils/global.dart' as global;
import 'package:flutter/services.dart';

class ThemeAndLanguageController extends GetxController {
  bool isDarkTheme = false;
  //!SECTION ------------------------Variable
  dynamic appLanguage;
  List<dynamic>? appLanguages;
  bool isHindi = true;
  Map<String, dynamic>? appLocaleValues;
  //!SECTION ------------------------Variable -/ -------------------------------------------------------

  //!SECTION-------------------------Functions

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    try {
      await getLanguage().then((value) {
        update();
      });
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "theme_controller",
        functionNameWithoutBraces: "init",
        e: e,
      );
    }
  }

  Future<void> getLanguage() async {
    try {
      appLanguages = await _getLanguageList();
      /* if (global.sp!.containsKey("languageCode")) {
        var code = global.sp!.get("languageCode");
        appLanguage = appLanguages!
            .where((e) => e['languageCode'] == code)
            .first;
      } else {
        appLanguage = appLanguages!
            .where((e) => e['languageCode'] == 'hi')
            .first;
      } */
      await setSystemLanguage();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "main.dart",
        functionNameWithoutBraces: "getLanguage",
        e: e,
      );
    }
  }

  Future<List<dynamic>?> _getLanguageList() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/locales/languages.json',
      );
      var result = jsonDecode(jsonString);

      return result;
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "main.dart",
        functionNameWithoutBraces: "_getLanguageList",
        e: e,
      );
      return null;
    }
  }

  Future<bool> setSystemLanguage() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/locales/${appLanguage['file']}',
      );
      appLocaleValues = jsonDecode(jsonString);
      return true;
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "dart",
        functionNameWithoutBraces: "setSystemLanguage",
        e: e,
      );
    }
    return false;
  }

  Future<dynamic> changelanguage(String? languageCode) async {
    try {
      if (appLanguage["languageCode"] != languageCode) {
        appLanguage = appLanguages!
            .where((e) => e['languageCode'] == languageCode)
            .first;
        if (appLanguage["languageCode"] == 'hi') {
          isHindi = true;
        } else {
          isHindi = false;
        }
        // await global.sp!.setBool('isTranslateText', isHindi);
      } else {
        log("Language Is Same");
      }

      await setSystemLanguage();
      // return global.sp!.setString("languageCode", appLanguage["languageCode"]);
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "dart",
        functionNameWithoutBraces: "changelanguage",
        e: e,
      );
    }
  }

  //!SECTION-------------------------Functions -/ ------------------------------------------------------
}
