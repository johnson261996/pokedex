import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RuleWidget extends StatelessWidget {
  final String name;
  final String? suffix;

  const RuleWidget({super.key, required this.name, this.suffix});

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
              'pokemon_special_rule'.trParams({'type': special}),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            Text(
              rulesToShow,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool isTagTeam() {
    return suffix?.toLowerCase().contains("tag team") ?? false;
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
    final s = suffix?.toLowerCase() ?? "";
    if (s.contains("tag team")) return "TAG TEAM";
    if (lower.endsWith(" vmax")) return "VMAX";
    if (lower.endsWith(" vstar")) return "VSTAR";
    if (lower.endsWith(" ex")) return "EX";
    if (lower.endsWith(" gx")) return "GX";
    if (lower.endsWith(" v")) return "V";

    return "";
  }

  String getDefaultRule(String name) {
    final lower = name.toLowerCase();
    final s = suffix?.toLowerCase() ?? "";

    /// ✅ TAG TEAM (highest priority)
    if (s.contains("tag team")) {
      return 'tag_team_rule'.tr;
    }
    const specialRules = {' ex': 'EX', ' gx': 'GX', ' v': 'V'};

    for (final MapEntry(key: suffix, value: type) in specialRules.entries) {
      if (lower.endsWith(suffix)) {
        return 'knocked_out_prize_cards'.trParams({'type': type});
      }
    }

    if (lower.endsWith(" vmax") || lower.endsWith(" vstar")) {
      return 'knocked_out_extra_prize_cards'.tr;
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
