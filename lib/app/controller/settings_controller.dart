import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';

class SettingsController extends GetxController {
  final HomeController homecontroller = Get.put(HomeController());
  var animationsEnabled = true.obs;
  final Box settingsBox = Hive.box('settings');

  var currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    final langCode = settingsBox.get("langCode", defaultValue: "en");
    final countryCode = settingsBox.get("countryCode", defaultValue: "US");

    currentLocale.value = Locale(langCode, countryCode);
    Get.updateLocale(currentLocale.value);

    super.onInit();
  }

  void changeLanguage(String langCode, String countryCode) {
    final locale = Locale(langCode, countryCode);

    currentLocale.value = locale;
    Get.updateLocale(locale);

    settingsBox.put("langCode", langCode);
    settingsBox.put("countryCode", countryCode);
    
    // Refresh Pokemon list to update translated names
    if (Get.isRegistered<HomeController>()) {
      homecontroller.fetchPokemonList();
    }
  }

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
