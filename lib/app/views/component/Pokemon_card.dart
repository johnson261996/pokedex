import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';
import 'package:pokemonapp/app/views/component/card_back.dart';
import 'package:pokemonapp/app/views/component/rarity_badge.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/utils/download_service.dart';

class PokemonCardWidget extends StatelessWidget {
  final TcgCardDetail card;

  const PokemonCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Tilt(
      borderRadius: BorderRadius.circular(16),
      tiltConfig: TiltConfig(
        angle: settings.animationsEnabled.value ? 10.0 : 0.0,
      ),
      child: FlipCard(
        flipOnTouch: settings.animationsEnabled.value,
        alignment: Alignment.topCenter,
        front: cardFront(),
        back:  Image.asset('assets/card/pokemon_card_backside.png', fit: BoxFit.cover),
      ),
    );
  }

  Card cardFront() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Stack(
        children: [
          Image.network(card.imageUrl, fit: BoxFit.cover),
          // Rarity badge
          Positioned(
            top: 10,
            right: 10,
            child: RarityBadge(rarity: card.rarity),
          ),
          // Download button
          Positioned(
            bottom: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  DownloadService.downloadPokemonCard(
                    imageUrl: card.imageUrl,
                    cardName: card.name,
                    context: Get.context!,
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
