import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';

class LangTile extends StatelessWidget {
  const LangTile({
    super.key,
    required this.title,
    required this.lang,
    required this.country,
  });

  final String title;
  final String lang;
  final String country;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Obx(() {
      final isSelected =
          controller.currentLocale.value.languageCode == lang &&
          controller.currentLocale.value.countryCode == country;

      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Get.theme.colorScheme.primary.withOpacity(0.12),
        trailing:
            isSelected
                ? Icon(Icons.check, color: Get.theme.colorScheme.primary)
                : null,
        onTap: () {
          controller.changeLanguage(lang, country);
          Get.back();
        },
      );
    });
  }
}
