import 'package:flutter/material.dart';
import 'package:pokemonapp/app/views/component/attack.dart';
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

          Text("${card.stage} Pokémon"),

          if (card.evolveFrom != null)
            Text(
              "Evolves from: ${card.evolveFrom}",
              style: const TextStyle(color: Colors.blue),
            ),

          const Divider(),

          /// ATTACKS
          ...card.attacks.map((a) => AttackWidget(attack: a)),

          const Divider(),

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
                    "${card.localId}/${card.setOfficialCards} ${card.rarity}",
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
}
