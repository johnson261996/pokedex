import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';

abstract class NetworkConnectionService {
  Future<List<ConnectivityResult>> checkConnectivity();
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class ConnectivityService implements NetworkConnectionService {
  const ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      _connectivity.checkConnectivity();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

class NetworkController extends GetxController {
  NetworkController({
    NetworkConnectionService? connectivity,
    Future<bool> Function()? internetCheck,
    HomeController? homeController,
  }) : _connectivity = connectivity ?? ConnectivityService(Connectivity()),
       _internetCheck = internetCheck ?? _defaultInternetCheck,
       _homeController = homeController;

  final NetworkConnectionService _connectivity;
  final Future<bool> Function() _internetCheck;
  final HomeController? _homeController;

  var isConnected = true.obs;
  var isWifiConnected = false.obs;

  HomeController get homeController =>
      _homeController ?? Get.find<HomeController>();

  static Future<bool> _defaultInternetCheck() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    refreshConnectionStatus();

    _connectivity.onConnectivityChanged.listen((status) {
      refreshConnectionStatus(status);
    });
  }

  Future<void> refreshConnectionStatus([
    List<ConnectivityResult>? status,
  ]) async {
    final currentStatus = status ?? await _connectivity.checkConnectivity();
    final hasConnectivity =
        currentStatus.contains(ConnectivityResult.mobile) ||
        currentStatus.contains(ConnectivityResult.wifi);

    final connected = hasConnectivity && await _internetCheck();
    final wifiConnected = currentStatus.contains(ConnectivityResult.wifi);

    final wasConnected = isConnected.value;
    isWifiConnected.value = wifiConnected;
    isConnected.value = connected;

    if (connected && !wasConnected && _homeController != null) {
      _homeController.reloadAfterReconnect();
      _homeController.fetchAllPokemonNames();
    } else if (!connected && wasConnected && _homeController != null) {
      _homeController.pokemonList.clear();
      _homeController.allPokemonList.clear();
    }

    if (connected != wasConnected) {
      try {
        if (Get.context != null) {
          Get.snackbar(
            connected ? 'Connected' : 'No Internet Connection',
            connected ? 'You are back online' : 'Please check your internet',
            snackPosition: SnackPosition.TOP,
            backgroundColor: connected ? Colors.green : Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
          );
        }
      } catch (_) {
        // Skip snackbar when the binding isn't ready yet (for example in tests).
      }
    }
  }
}
