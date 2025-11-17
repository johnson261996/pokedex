import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    /// Initial check
    _connectivity.checkConnectivity().then((status) {
      updateConnectionStatus(status);
    });

    /// Listener
    _connectivity.onConnectivityChanged.listen((status) {
      updateConnectionStatus(status);
    });
  }

  /// ACCEPT ONLY ConnectivityResult (NOT a List)
  void updateConnectionStatus(List<ConnectivityResult> status) {
    bool connected =
        status.contains(ConnectivityResult.mobile) ||
        status.contains(ConnectivityResult.wifi);

    if (connected != isConnected.value) {
      isConnected.value = connected;

      /// 🔥 Snackbar on top
      Get.snackbar(
        connected ? "Connected" : "No Internet Connection",
        connected ? "You are back online" : "Please check your internet",
        snackPosition: SnackPosition.TOP,
        backgroundColor: connected ? Colors.green : Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }
}
