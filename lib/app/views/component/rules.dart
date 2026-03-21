import 'package:flutter/material.dart';

class RuleWidget extends StatelessWidget {
  final String name;

  const RuleWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final rulesToShow = displayRules(name);
    final special = extractSpecialType(name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rulesToShow.isNotEmpty) ...[
            Text(
              "Pokémon $special rule",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            Text(
              rulesToShow,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  bool isSpecialCard(String name) {
    final lower = name.toLowerCase();

    return lower.endsWith(" ex") ||
        lower.endsWith(" gx") ||
        lower.endsWith(" v") ||
        lower.endsWith(" vmax") ||
        lower.endsWith(" vstar");
  }

  String extractSpecialType(String name) {
    final lower = name.toLowerCase();

    if (lower.endsWith(" vmax")) return "VMAX";
    if (lower.endsWith(" vstar")) return "VSTAR";
    if (lower.endsWith(" ex")) return "EX";
    if (lower.endsWith(" gx")) return "GX";
    if (lower.endsWith(" v")) return "V";

    return "";
  }

  String getDefaultRule(String name) {
    final lower = name.toLowerCase();

    const specialRules = {' ex': 'EX', ' gx': 'GX', ' v': 'V'};

    for (final MapEntry(key: suffix, value: type) in specialRules.entries) {
      if (lower.endsWith(suffix)) {
        return "When your Pokémon-$type is Knocked Out, your opponent takes 2 Prize cards.";
      }
    }

    if (lower.endsWith(" vmax") || lower.endsWith(" vstar")) {
      return "When your Pokémon is Knocked Out, your opponent takes extra Prize cards.";
    }

    return "";
  }

  String displayRules(String name) {
    if (isSpecialCard(name)) {
      final fallback = getDefaultRule(name);
      if (fallback.isNotEmpty) {
        return fallback;
      }
    }

    return "";
  }
}
