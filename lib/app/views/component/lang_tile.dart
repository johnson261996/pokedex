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
    return _langTile(title, lang, country);
  }

  Widget _langTile(String title, String lang, String country) {
    final controller = Get.find<SettingsController>();

    return ListTile(
      title: Text(title),

      onTap: () {
        controller.changeLanguage(lang, country);
        Get.back();
      },
    );
  }
}
