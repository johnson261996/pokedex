import 'package:flutter/material.dart';
import 'package:pokemonapp/app/views/component/ability.dart';
import 'package:pokemonapp/app/views/component/attack.dart';
import 'package:pokemonapp/app/views/component/rules.dart';
import 'package:pokemonapp/app/views/component/weakness.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class CardBack extends StatelessWidget {
  final TcgCardDetail card;

  const CardBack({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  Text("HP ${card.hp ?? ''}"),
                  Text(
                    PokemonTypeColor.energyIcon(card.types?.first ?? ""),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),
          if (card.stage != null) Text("${card.stage} Pokémon"),

          if (card.evolveFrom != null)
            Text(
              "Evolves from: ${card.evolveFrom}",
              style: const TextStyle(color: Colors.blue),
            ),

          const SizedBox(height: 6),

          /// ABILITIES
          if (card.abilities.isNotEmpty) ...[
            ...card.abilities.map((a) => AbilityWidget(ability: a)),
          ],

          const Divider(),

          /// ATTACKS
          ...card.attacks.map((a) => AttackWidget(attack: a)),

          const Divider(),
          if (isSpecialCard(card.name)) ...[
            /// RULES
            RuleWidget(name: card.name),
          ],
          const SizedBox(height: 6),

          /// WEAKNESS ROW
          weaknessRow(card),

          const SizedBox(height: 12),

          /// SET INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${card.setName}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    int.tryParse(card.localId!) == null ? card.localId! : "${int.parse(card.localId!)}/${card.setOfficialCards} ${card.rarity}",
                  ),
                ],
              ),

              if (card.setSymbol != null && card.setSymbol!.isNotEmpty)
                Image.network("${card.setSymbol}.png", height: 30),
            ],
          ),

          const SizedBox(height: 12),

          /// ILLUSTRATOR
          Text(
            "Illustrator: ${card.illustrator}",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  bool isSpecialCard(String name) {
    final lower = name.toLowerCase();

    return lower.contains("ex") ||
        lower.contains("gx") ||
        lower.contains(" v") || // important: space before v
        lower.contains(" vmax") ||
        lower.contains(" vstar");
  }
}
