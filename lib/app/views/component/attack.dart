import 'package:flutter/material.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class AttackWidget extends StatelessWidget {
  final Map attack;

  const AttackWidget({super.key, required this.attack});

  @override
  Widget build(BuildContext context) {
    final cost = attack["cost"] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...cost.map<Widget>(
                (c) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    PokemonTypeColor.energyIcon(c),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  attack["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Text(
                attack["damage"]?.toString() ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          if (attack["effect"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                attack["effect"],
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}
