import 'dart:developer';
import 'package:flutter/material.dart';

class Helper extends StatelessWidget {
  const Helper({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  double getDeviceheight(BuildContext context) {
    try {
      return MediaQuery.of(context).size.height;
    } catch (e) {
      log("Excption: Helper.dart : getDeviceheight() : $e");
      return 0;
    }
  }

  double getDevicewidth(BuildContext context) {
    try {
      return MediaQuery.of(context).size.width;
    } catch (e) {
      log("Excption: Helper.dart : getDevicewidth() : $e");
      return 0;
    }
  }
}
