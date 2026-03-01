//flutter
import 'dart:async';
//packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/utils/global.dart' as global;

class NetworkController extends GetxController {
  //** variables
  var connectionStatus = 0.obs;
  //** objects
  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      updateConnectivity,
    );
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult>? result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "network_controller.dart",
        functionNameWithoutBraces: "initConnectivity",
        e: e,
      );
    }
    return updateConnectivity(result ?? []);
  }

  void updateConnectivity(List<ConnectivityResult> results) {
    ConnectivityResult result = results.isNotEmpty
        ? results.last
        : ConnectivityResult.none;
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        Get.snackbar(
          'Netowrk Error',
          'No internet connection over there',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        );
        break;

      default:
    }
  }
}
