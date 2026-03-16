import 'package:flutter/material.dart';
import 'package:pokemonapp/app/views/component/Pokemon_card.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

class CardGallery extends StatelessWidget {

  final List<TcgCardDetail> cards;
  final TcgCardDetail tcgCardDetail;
  const CardGallery({super.key, required this.cards, required this.tcgCardDetail});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: PageView.builder(
        itemCount: cards.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (_, index) {

          final card = cards[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PokemonCardWidget(card: card),
          );
        },
      ),
    );
  }
}