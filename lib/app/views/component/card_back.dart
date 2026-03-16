import 'package:flutter/material.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

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
          Text(
            card.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Text("HP ${card.hp ?? '-'}"),

          const SizedBox(height: 10),
          Text("Set: ${card.set ?? 'Unknown'}"),

          const SizedBox(height: 10),

          Text("Rarity: ${card.rarity ?? 'Unknown'}"),
          const SizedBox(height: 10),
          Text("Set: ${card.set}"),
          const SizedBox(height: 10),
          Text("Illustrator: ${card.illustrator ?? '-'}"),

          const Spacer(),

          // SetLogo(setId: card.setId),
        ],
      ),
    );
  }
}
