import 'package:flutter/material.dart';

class RarityBadge extends StatelessWidget {

  final String? rarity;

  const RarityBadge({super.key, this.rarity});

  Color getColor() {

    switch(rarity){

      case "Rare":
        return Colors.orange;

      case "Ultra Rare":
        return Colors.purple;

      case "Common":
        return Colors.grey;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Text(
        rarity ?? "Unknown",
        style: const TextStyle(
            color: Colors.white,
            fontSize: 12),
      ),
    );
  }
}