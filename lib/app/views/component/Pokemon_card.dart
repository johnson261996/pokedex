import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:pokemonapp/app/views/component/card_back.dart';
import 'package:pokemonapp/app/views/component/rarity_badge.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

class PokemonCardWidget extends StatelessWidget {
  final TcgCardDetail card;

  const PokemonCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Tilt(
      borderRadius: BorderRadius.circular(16),

      child: FlipCard(
        alignment: Alignment.topCenter,
        front: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,

          child: Stack(
            children: [
              Image.network(card.imageUrl, fit: BoxFit.cover),

              Positioned(
                top: 10,
                right: 10,
                child: RarityBadge(rarity: card.rarity),
              ),
            ],
          ),
        ),

        back: CardBack(card: card),
      ),
    );
  }
}
