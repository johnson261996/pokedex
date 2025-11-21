import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;
  final settingsBox = Hive.box('settings');

  @override
  void onInit() {
    isDark.value = settingsBox.get('dark', defaultValue: false);
    super.onInit();
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    settingsBox.put('dark', isDark.value);
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}
