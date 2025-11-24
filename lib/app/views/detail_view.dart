import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/detail_controller.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final detail = controller.pokemonDetail.value;
          if (detail == null) {
            return Text("Loading...");
          }
          return Text(
            '#${detail.id} ${detail.name.capitalizeFirst ?? detail.name}',
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final detail = controller.pokemonDetail.value!;
        final evoList = controller.evolutionList;
        final desc = controller.description.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Pokémon Image
              Center(
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${detail.id}.png',
                  height: 250,
                  width: 250,
                ),
              ),

              const SizedBox(height: 16),
              if (desc.isNotEmpty)
                Text(
                  desc,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 16),

              /// Basic Info
              Text('Height: ${detail.height}'),
              Text('Weight: ${detail.weight}'),

              const SizedBox(height: 16),
              const Text(
                "Type",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              /// Types
              Wrap(
                spacing: 8,
                runSpacing: 8,
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
              const Text(
                "Weaknesses",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    controller.weaknesses
                        .map(
                          (w) => Chip(
                            label: Text(
                              w.capitalize!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: PokemonTypeColor.get(w),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),

              /// Abilities
              Text(
                'Abilities: ${detail.abilities.map((a) => a.name.capitalize).join(', ')}',
              ),

              const SizedBox(height: 24),
              const Text(
                "Stats",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...detail.stats.map(
                (s) => statBar(s.name.capitalize!, s.baseStat),
              ),

              /// Evolution Section
              if (evoList.isNotEmpty) ...[
                const Text(
                  "Evolution Chain",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (controller.evolutionList.length <= 1)
                  const Text(
                    "This Pokémon does not evolve.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                SizedBox(
                  height: 130,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: evoList.length,
                      separatorBuilder: (_, index) {
                        // Add arrow between items, except after the last
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              "➡",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      itemBuilder: (_, index) {
                        final name = evoList[index];
                        final id = controller.evolutionIdMap[name];

                        /// Fetch Pokémon detail image by name
                        if (id == null) {
                          return const SizedBox(
                            width: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final img =
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${controller.evolutionIdMap[name] ?? detail.id}.png";

                        return GestureDetector(
                          onTap: () async {
                            controller.isLoading.value = true;
                            controller.changePokemon(name);
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            controller.isLoading.value = false;
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
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget statBar(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $value"),
        SizedBox(
          height: 8,
          child: LinearProgressIndicator(
            value: value / 200, // max base stat ~200
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
