import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/controllers/network_controller.dart';
import 'package:todo/controllers/theme_controller.dart';
import 'package:todo/models/user_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//!----------------------------------------------------------------------Variables----------------------------------------------------------------------------------
///* int */

///* string */

///* Controller */
ThemeAndLanguageController themeController =
    Get.find<ThemeAndLanguageController>();
NetworkController networkController = Get.put(NetworkController());

///* Local Storage */
SharedPreferences? sp;

////* Api Parameter */
String imageBaseUrl = "http://indiarides.voidek.in/public/assets//users_imgs/";
String appMode = "LIVE";
Map<String, dynamic> appParameters = {
  "LIVE": {
    "apiUrl": "http://indiarides.voidek.in/api/",
    "imageBaseurl": "http://indiarides.voidek.in/public/assets//users_imgs/",
  },
  "DEV": {"apiUrl": "http://192.168.29.123:1401/"},
};
String appId = "shared_ride_app";

///* Others */
Map<int, Color> lightColor = {
  50: const Color.fromRGBO(0, 0, 255, .1),
  100: const Color.fromRGBO(0, 0, 255, .2),
  200: const Color.fromRGBO(0, 0, 255, .3),
  300: const Color.fromRGBO(0, 0, 255, .4),
  400: const Color.fromRGBO(0, 0, 255, .5),
  500: const Color.fromRGBO(0, 0, 255, .6),
  600: const Color.fromRGBO(0, 0, 255, .7),
  700: const Color.fromRGBO(0, 0, 255, .8),
  800: const Color.fromRGBO(0, 0, 255, .9),
  900: const Color.fromRGBO(0, 0, 255, 1),
};
Map<int, Color> darkColor = {
  50: const Color.fromRGBO(0, 0, 0, .1),
  100: const Color.fromRGBO(0, 0, 0, .2),
  200: const Color.fromRGBO(0, 0, 0, .3),
  300: const Color.fromRGBO(0, 0, 0, .4),
  400: const Color.fromRGBO(0, 0, 0, .5),
  500: const Color.fromRGBO(0, 0, 0, .6),
  600: const Color.fromRGBO(0, 0, 0, .7),
  700: const Color.fromRGBO(0, 0, 0, .8),
  800: const Color.fromRGBO(0, 0, 0, .9),
  900: const Color.fromRGBO(0, 0, 0, 1),
};

//!----------------------------------------------------------------------Functions--------------------------------------------------------------------------------------
///* Loaders */
Future<dynamic> showOnlyLoaderDialog() {
  try {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "showOnlyLoaderDialog",
      e: e,
    );
    return Future.value();
  }
}

////* hideLoader */
void hideLoader() {
  try {
    Get.back();
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "hideLoader",
      e: e,
    );
  }
}

///* Dialogs */
Future<dynamic> showExitDialog(BuildContext context) async {
  try {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure, you want to exit App?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(onPressed: () => exit(0), child: const Text("Exit")),
          ],
        );
      },
    );
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "showExitDialog",
      e: e,
    );
  }
}

////* commonDialog */
dynamic commonDialog(
  BuildContext context, {
  required String? titleText,
  required String? contentText,
  required String? leftActionButtonText,
  required String? rightActionButtonText,
  required void Function()? leftActionButtonOnPressed,
  required void Function()? rightActionButtonOnPressed,
}) {
  try {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText ?? "-"),
          content: Text(contentText ?? "-"),
          actions: <Widget>[
            TextButton(
              onPressed: leftActionButtonOnPressed,
              child: Text(leftActionButtonText ?? "-"),
            ),
            TextButton(
              onPressed: rightActionButtonOnPressed,
              child: Text(rightActionButtonText ?? "-"),
            ),
          ],
        );
      },
    );
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "commonDialog",
      e: e,
    );
  }
}

///* For Network controller */
Future<bool> checkBody() async {
  bool result;
  try {
    await networkController.initConnectivity();
    if (networkController.connectionStatus.value != 0) {
      result = true;
    } else {
      Get.snackbar(
        "Warning",
        "No Internet Connection",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(days: 1),
        colorText: Colors.black,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.signal_wifi_off, color: Colors.black),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "No Internet Available",
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (networkController.connectionStatus.value != 0) {
                  Get.back();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.black),
                height: 30,
                width: 55,
                child: Center(
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: Theme.of(Get.context!).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      result = false;
    }

    return result;
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "checkBody",
      e: e,
    );
    return false;
  }
}

////* Snackbar */
SnackbarController showSnackBar(String title, String text) {
  return Get.snackbar(
    title,
    text,
    dismissDirection: DismissDirection.horizontal,
    showProgressIndicator: false,
    progressIndicatorBackgroundColor: AppColor.blackColor,
    isDismissible: true,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
  );
}

////* Exception Message OR Log OR Print */
void exceptionMessage({
  required String? classNameWithoutExt,
  required String? functionNameWithoutBraces,
  required Object? e,
}) {
  try {
    log(
      "Exception: $classNameWithoutExt.dart: $functionNameWithoutBraces(): $e",
      time: DateTime.now(),
    );
  } catch (e) {
    log("Exception: global.dart: exceptionMessage(): $e");
  }
}

////* apiHeader */
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  try {
    Map<String, String>? apiHeader = <String, String>{};

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "deviceModel": androidInfo.model,
        "deviceManufacturer": androidInfo.manufacturer,
        "deviceId": androidInfo.id,
        // "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "deviceModel": iosInfo.model,
        "deviceManufacturer": "Apple",
        "deviceId": iosInfo.identifierForVendor,
        // "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    }

    if (authorizationRequired) {
      sp = await SharedPreferences.getInstance();
      if (sp!.getString("currentUser") != null) {
        UserModel userModel = UserModel.fromJson(
          json.decode(sp!.getString("currentUser")!),
        );
        log("Session token: ${userModel.sessionToken}");
        apiHeader.addAll({"Authorization": userModel.sessionToken!});
      } else {
        apiHeader.addAll({"Authorization": appId});
      }
    } else {
      apiHeader.addAll({"Authorization": appId});
    }
    apiHeader.addAll({"Content-Type": "application/json"});
    apiHeader.addAll({"Accept": "application/json"});
    apiHeader.addAll({"DeviceInfo": json.encode(deviceData)});
    log(apiHeader.toString());
    return apiHeader;
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "getApiHeaders",
      e: e,
    );
    return {"": ""};
  }
}

////* navigation screen to */
void navigateTo(Widget redirectScreenName) {
  try {
    Get.to(
      () => redirectScreenName,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 800),
    );
  } catch (e) {
    exceptionMessage(
      classNameWithoutExt: "global",
      functionNameWithoutBraces: "navigateTo",
      e: e,
    );
  }
}
