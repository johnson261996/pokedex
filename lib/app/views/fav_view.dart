import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/favorites_controller.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Pokémon")),

      body: Obx(() {
        if (favController.favoriteList.isEmpty) {
          return const Center(child: Text("No favorites yet"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
          ),
          itemCount: favController.favoriteList.length,
          itemBuilder: (_, index) {
            final pokemon = favController.favoriteList[index];

            return Card(
              elevation: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Image.network(pokemon.imageUrl, height: 100)),
                  Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("#${pokemon.id}"),
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => favController.toggleFavorite(pokemon),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
