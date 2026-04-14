import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';
import 'package:pokemonapp/app/controller/theme_controller.dart';
import 'package:pokemonapp/app/views/component/lang_tile.dart';

class SettingsPage extends StatelessWidget {
  final controller = Get.put(SettingsController());
  final themeCtrl = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings".tr)),

      body: ListView(
        children: [
          /// LANGUAGE
          ListTile(
            title: Text("language".tr),
            leading: const Icon(Icons.language),

            onTap: () {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LangTile(title: "English", lang: "en", country: "US"),
                      LangTile(title: "Español", lang: "es", country: "ES"),
                      LangTile(title: "日本語", lang: "ja", country: "JP"),
                    ],
                  ),
                ),
              );
            },
          ),

          /// THEME
          Obx(
            () => SwitchListTile(
              title: Text("dark_mode".tr),
              value: themeCtrl.isDark.value,
              onChanged: (_) => themeCtrl.toggleTheme(),
            ),
          ),

          /// ANIMATIONS
          Obx(
            () => SwitchListTile(
              title: Text("enable_animations".tr),
              value: controller.animationsEnabled.value,
              onChanged: (_) => controller.toggleAnimations(),
            ),
          ),

          const Divider(),

          /// CLEAR RECENT SEARCHES
          ListTile(
            title: Text("clear_search".tr),
            trailing: const Icon(Icons.delete),
            onTap: () {
              controller.clearRecentSearches();

              Get.snackbar("cleared".tr, "recent_searches_removed".tr);
            },
          ),

          const Divider(),

          /// ABOUT
          ListTile(
            title: Text("about_app".tr),
            subtitle: Text("pokemon_tcg_viewer".tr),
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
