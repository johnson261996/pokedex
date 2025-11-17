import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/detail_controller.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon Detail')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final detail = controller.pokemonDetail.value!;
        final evoList = controller.evolutionList;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Pokémon Title
              Text(
                '#${detail.id} ${detail.name.capitalizeFirst}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Pokémon Image
              Center(
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${detail.id}.png',
                  height: 250,
                  width: 250,
                ),
              ),

              const SizedBox(height: 16),

              /// Basic Info
              Text('Height: ${detail.height}'),
              Text('Weight: ${detail.weight}'),

              const SizedBox(height: 16),

              /// Types
              Wrap(
                spacing: 8,
                children:
                    detail.types.map((t) {
                      final typeName = t.name;
                      final color = PokemonTypeColor.get(typeName);

                      return Chip(
                        label: Text(
                          typeName.capitalize!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: color,
                      );
                    }).toList(),
              ),

              const SizedBox(height: 16),

              /// Abilities
              Text(
                'Abilities: ${detail.abilities.map((a) => a.name.capitalize).join(', ')}',
              ),

              const SizedBox(height: 24),

              /// Evolution Section
              if (evoList.isNotEmpty) ...[
                const Text(
                  "Evolution Chain",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: evoList.length,
                    itemBuilder: (_, index) {
                      final name = evoList[index];

                      /// Fetch Pokémon detail image by name
                      final img =
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${controller.evolutionIdMap[name] ?? detail.id}.png";

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed("/detail", arguments: name);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Image.network(img, height: 80),
                              const SizedBox(height: 6),
                              Text(
                                name.capitalize ?? "",
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
