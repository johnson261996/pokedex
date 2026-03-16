import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemonapp/app/views/component/card_gallery.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

class CardDetailPage extends StatelessWidget {
  final TcgCardDetail card;

  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      body: CardGallery(cards:  [card], tcgCardDetail: card),
/* 
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CARD IMAGE
            Padding(
              padding: const EdgeInsets.all(16),
              child: card.image.isNotEmpty
                  ? Image.network(card.imageUrl, fit: BoxFit.cover)
                  : Container(
                      height: 200,
                      width: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
            ),

            // CARD INFO
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      Text("HP ${card.hp ?? '-'}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text("Set: ${card.set ?? 'Unknown'}"),

                  const SizedBox(height: 10),

                  Text("Rarity: ${card.rarity ?? 'Unknown'}"),

                  const SizedBox(height: 10),

                  Text("Illustrator: ${card.illustrator ?? '-'}"),
                ],
              ),
            ),
          ],
        ),
      ), */
    );
  }
}
