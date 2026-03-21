import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RuleWidget extends StatelessWidget {
  final String name;

  const RuleWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final rulesToShow = displayRules(name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rulesToShow.isNotEmpty) ...[
            Text(
              "Pokémon ex rule",
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

  String getDefaultRule(String name) {
    final lower = name.toLowerCase();

    if (lower.endsWith(" ex")) {
      return "When your Pokémon-EX is Knocked Out, your opponent takes 2 Prize cards.";
    }

    if (lower.endsWith(" gx")) {
      return "When your Pokémon-GX is Knocked Out, your opponent takes 2 Prize cards.";
    }

    if (lower.endsWith(" v")) {
      return "When your Pokémon V is Knocked Out, your opponent takes 2 Prize cards.";
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
