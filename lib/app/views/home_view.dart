import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/favorites_controller.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/app/controller/network_controller.dart';
import 'package:pokemonapp/app/controller/theme_controller.dart';
import 'package:pokemonapp/app/routes/app_pages.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/utils/sort_type.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final favController = Get.find<FavoritesController>();
  final networkController = Get.find<NetworkController>();
  final themeCtrl = Get.find<ThemeController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    searchController.dispose();
  }

  Future<void> _pullRefresh() async {
    controller.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              themeCtrl.isDark.value ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: themeCtrl.toggleTheme,
          ),
          PopupMenuButton(
            onSelected: (value) {
              controller.sortType.value = value;
              controller.sortPokemon();
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: SortType.lowestNumber,
                    child: Text("Lowest Number"),
                  ),
                  const PopupMenuItem(
                    value: SortType.highestNumber,
                    child: Text("Highest Number"),
                  ),
                  const PopupMenuItem(
                    value: SortType.aToZ,
                    child: Text("A → Z"),
                  ),
                  const PopupMenuItem(
                    value: SortType.zToA,
                    child: Text("Z → A"),
                  ),
                ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Obx(() {
          return Stack(
            children: [
              _buildMainContent(),
              // 👇 SUGGESTION DROPDOWN
              if (controller.showSuggestions.value &&
                  controller.suggestions.isNotEmpty)
                _buildOverlaySuggestions(),
            ],
          );
        }),
      ),
    );
  }

  Column _buildMainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Search Pokémon by name...",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              controller.searchQuery.value = value;
            },
            onSubmitted: (value) {
              controller.searchPokemon(value.trim());
              controller.showSuggestions.value = false;
            },
          ),
        ),
        // Random button
        ElevatedButton(
          onPressed: () => controller.getMultipleRandomPokemon(20),
          child: const Text("🎲 Random Pokémon"),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            if (!networkController.isConnected.value) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, size: 70, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      "No internet connection",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (networkController.isConnected.value) {
                          controller.fetchPokemonList();
                        }
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.pokemonList.isEmpty) {
              return const Center(child: Text("No Pokémon found"));
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(child: Text(controller.errorMessage.value));
            }

            return GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
              ),
              itemCount:
                  controller.pokemonList.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index == controller.pokemonList.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final pokemon = controller.pokemonList[index];
                return pokemonCard(pokemon);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOverlaySuggestions() {
    return Positioned(
      left: 12,
      right: 12,
      top: 65, // 👈 Position it below the search bar
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeCtrl.isDark.value ? Colors.black : Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.suggestions.length,
            itemBuilder: (_, index) {
              final name = controller.suggestions[index];
              return ListTile(
                dense: true,
                title: Text(
                  name.capitalizeFirst ?? name,
                  style: TextStyle(
                    color: themeCtrl.isDark.value ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  controller.searchPokemon(name);
                  controller.showSuggestions.value = false;
                },
              );
            },
          ),
        ),
      ),
    );
  }

  GestureDetector pokemonCard(PokemonDetail pokemon) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.DETAIL, arguments: pokemon.name);
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Obx(
                () => Icon(
                  favController.isFavorite(pokemon)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                favController.toggleFavorite(pokemon);
              },
            ),
            Expanded(
              child: FadeInImage.assetNetwork(
                placeholder:
                    'assets/icons/ball.png', // Path to your local placeholder image
                image: pokemon.imageUrl, // URL of the network image
                fit: BoxFit.cover, // Adjust as needed
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            /// Types
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  pokemon.types.map((t) {
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
