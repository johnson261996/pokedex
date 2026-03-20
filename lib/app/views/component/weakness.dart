import 'package:flutter/widgets.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/utils/type_colors.dart';

Widget weaknessRow(TcgCardDetail card) {
  final weakness = card.weaknesses.isNotEmpty ? card.weaknesses.first : null;

  final resistance =
      card.resistances!.isNotEmpty ? card.resistances!.first : null;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Column(
        children: [
          const Text("Weakness"),
          if (weakness != null && weakness["value"] != null)
            Row(
              children: [
                Text(PokemonTypeColor.energyIcon(weakness["type"])),
                Text(weakness["value"]),
              ],
            ),
        ],
      ),

      Column(
        children: [
          const Text("Resistance"),
          if (resistance != null && resistance["value"] != null)
            Row(
              children: [
                Text(PokemonTypeColor.energyIcon(resistance["type"])),
                Text(resistance["value"]),
              ],
            ),
        ],
      ),

      Column(
        children: [
          const Text("Retreat Cost"),
          Row(
            children: List.generate(card.retreat ?? 0, (_) => const Text("⭐")),
          ),
        ],
      ),
    ],
  );
}
