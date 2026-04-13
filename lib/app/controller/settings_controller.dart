import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';

class SettingsController extends GetxController {
  final HomeController homecontroller = Get.put(HomeController());
  var animationsEnabled = true.obs;

  void toggleAnimations() {
    animationsEnabled.value = !animationsEnabled.value;
  }

  void clearRecentSearches() {
    homecontroller.recentSearches.clear();
    // connect with your existing recent search storage
    // example:
    // storage.remove("recent_searches");
  }
}