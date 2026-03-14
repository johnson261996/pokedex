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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),

              const SizedBox(height: 16),
              // Pokémon Details Card
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pokemon Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Height: ${_formatHeight(detail.height)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Weight: ${_formatWeight(detail.weight)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Obx(
                        () => Text(
                          'Category: ${controller.category.value.isNotEmpty ? controller.category.value : 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Abilities: ', style: TextStyle(fontSize: 16)),
                      Wrap(
                        spacing: 12,
                        runSpacing: 0,
                        children:
                            detail.abilities.map((ability) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ability.name.capitalize!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.info_outline, size: 20),
                                    onPressed:
                                        () => _showAbilityDialog(
                                          controller,
                                          context,
                                          ability.name,
                                        ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),

                      Row(
                        children: [
                          Text('Gender:', style: TextStyle(fontSize: 16)),
                          Icon(Icons.male, color: Colors.blue, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.female, color: Colors.pink, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

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

  String _formatHeight(int heightDecimeters) {
    // Convert decimeters to inches: 1 dm = 3.937 inches
    double inches = heightDecimeters * 3.937;
    int feet = inches ~/ 12;
    int remainingInches = (inches % 12).round();
    return "$feet' ${remainingInches.toString().padLeft(2, '0')}\"";
  }

  String _formatWeight(int weightHectograms) {
    // Convert hectograms to lbs: 1 hg = 0.220462 lbs
    double lbs = weightHectograms * 0.220462;
    return "${lbs.toStringAsFixed(1)} lbs";
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

  void _showAbilityDialog(
    DetailController controller,
    BuildContext context,
    String abilityName,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(abilityName.capitalize!),
          content: FutureBuilder(
            future: controller.getAbilityDetails(abilityName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error loading ability description');
              } else if (snapshot.hasData) {
                final ability = snapshot.data!;
                return Text(ability.description);
              } else {
                return const Text('No description available');
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
