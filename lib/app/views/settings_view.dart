import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';
import 'package:pokemonapp/app/controller/theme_controller.dart';

class SettingsPage extends StatelessWidget {

  final controller = Get.put(SettingsController());
    final themeCtrl = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        children: [

          /// THEME
          Obx(() => SwitchListTile(
                title: const Text("Dark Mode"),
                value: themeCtrl.isDark.value,
                onChanged: (_) => themeCtrl.toggleTheme(),
              )),

          /// ANIMATIONS
          Obx(() => SwitchListTile(
                title: const Text("Enable Animations"),
                value: controller.animationsEnabled.value,
                onChanged: (_) => controller.toggleAnimations(),
              )),

          const Divider(),

          /// CLEAR RECENT SEARCHES
          ListTile(
            title: const Text("Clear Recent Searches"),
            trailing: const Icon(Icons.delete),
            onTap: () {
              controller.clearRecentSearches();

              Get.snackbar(
                "Cleared",
                "Recent searches removed",
              );
            },
          ),

          const Divider(),

          /// ABOUT
          ListTile(
            title: const Text("About App"),
            subtitle: const Text("Pokémon TCG Viewer"),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Pokemon App",
                applicationVersion: "1.0.0",
              );
            },
          ),
        ],
      ),
    );
  }
}