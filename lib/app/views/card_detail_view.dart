import 'package:flutter/material.dart';
import 'package:pokemonapp/app/views/component/card_gallery.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

class CardDetailPage extends StatelessWidget {
  final TcgCardDetail card;

  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      body: CardGallery(cards: [card], tcgCardDetail: card),
    );
  }
}
