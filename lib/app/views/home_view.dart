import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/card_controller.dart';
import 'package:pokemonapp/app/controller/compare_controller.dart';
import 'package:pokemonapp/app/controller/favorites_controller.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/app/controller/network_controller.dart';
import 'package:pokemonapp/app/controller/theme_controller.dart';
import 'package:pokemonapp/app/routes/app_pages.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/utils/sort_type.dart';
import 'package:pokemonapp/utils/type_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
  }

  Future<void> _pullRefresh() async {
    controller.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.showRecent.value = false;
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("pokedex".tr),
          actions: <Widget>[
            PopupMenuButton(
              position:
                  PopupMenuPosition.over, // Place the menu below the button
              offset: Offset(
                0,
                40,
              ), // Shift the menu 50 logical pixels downwards
              onSelected: (value) {
                controller.sortType.value = value;
                controller.sortPokemon();
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: SortType.lowestNumber,
                      child: Text("sort_lowest_number".tr),
                    ),
                    PopupMenuItem(
                      value: SortType.highestNumber,
                      child: Text("sort_highest_number".tr),
                    ),
                    PopupMenuItem(
                      value: SortType.aToZ,
                      child: Text("sort_a_to_z".tr),
                    ),
                    PopupMenuItem(
                      value: SortType.zToA,
                      child: Text("sort_z_to_a".tr),
                    ),
                  ],
              icon: const Icon(Icons.sort),
            ),
            // Filter Types Button
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () => _openFilterSheet(),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Obx(() {
              return Stack(
                children: [
                  _buildMainContent(),
                  if (controller.searchQuery.isEmpty &&
                      controller.recentSearches.isNotEmpty &&
                      controller.showRecent.value)
                    recentSearches(),

                  // 👇 SUGGESTION DROPDOWN
                  if (controller.showSuggestions.value &&
                      controller.suggestions.isNotEmpty)
                    _buildOverlaySuggestions(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Positioned recentSearches() {
    return Positioned(
      left: 12,
      right: 12,
      top: 65,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: themeCtrl.isDark.value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "recent_searches".tr,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: controller.clearAllRecentSearches,
                    child: Text(
                      "clear_all".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.recentSearches.length,
              itemBuilder: (_, index) {
                final name = controller.recentSearches[index];
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text(name.capitalizeFirst!),
                  trailing: IconButton(
                    onPressed: () {
                      controller.removeRecentSearch(name);
                    },
                    icon: Icon(Icons.close),
                  ),
                  onTap: () => controller.onRecentSearchSelected(name),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    final controller = Get.find<HomeController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) {
        return Obx(
          () => Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "filter_by_type".tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      controller.allTypes.map((type) {
                        final selected = controller.selectedTypeFilter.contains(
                          type,
                        );
                        return FilterChip(
                          label: Text(type.toUpperCase()),
                          selected: selected,
                          selectedColor: PokemonTypeColor.get(type),
                          backgroundColor: PokemonTypeColor.get(type),
                          onSelected: (value) {
                            if (value) {
                              controller.selectedTypeFilter.add(type);
                            } else {
                              controller.selectedTypeFilter.remove(type);
                            }
                            controller.applyFilter();
                          },
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedTypeFilter.isNotEmpty) {
                      controller.selectedTypeFilter.clear();
                      controller.fetchPokemonList();
                    }

                    Get.back();
                  },
                  child: Text("clear_filters".tr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _buildMainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,

            onTap: () {
              controller.showRecent.value = true;
            },
            decoration: InputDecoration(
              hintText: "search_pokemon_hint".tr,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
              suffixIcon:
                  controller.showClose.value
                      ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          controller.showSuggestions.value = false;
                          controller.showClose.value = false;
                          controller.showRecent.value = true;
                          controller.searchQuery.value = '';
                        },
                        icon: Icon(Icons.close),
                      )
                      : SizedBox(),
            ),
            onChanged: (value) {
              controller.searchQuery.value = value;
              if (value.isNotEmpty) {
                controller.showClose.value = true;
              } else {
                controller.showClose.value = false;
              }
            },
            onSubmitted: (value) {
              controller.searchPokemon(value.trim());
              controller.showSuggestions.value = false;
            },
          ),
        ),

        // Random button
        ElevatedButton(
          onPressed: () => controller.getMultipleRandomPokemon(100),
          child: Text("random_pokemon".tr),
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
                      "no_internet_connection".tr,
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
                          controller.fetchAllPokemonNames();
                        }
                      },
                      child: Text("retry".tr),
                    ),
                  ],
                ),
              );
            }
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.pokemonList.isEmpty) {
              return Center(child: Text("no_pokemon_found".tr));
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(child: Text(controller.errorMessage.value));
            }

            if (controller.isFiltering.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: Platform.isWindows ? 1.1 : 0.75,
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
              final item = controller.suggestions[index];
              final name = item["name"];
              final id = controller.extractId(item["url"]);
              final imageUrl =
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png";

              return ListTile(
                title: Text(
                  name,
                  style: TextStyle(
                    color: themeCtrl.isDark.value ? Colors.white : Colors.black,
                  ),
                ),
                leading: Image.network(imageUrl, width: 50, height: 50),
                subtitle: Text("#$id"),
                onTap: () {
                  searchController.text = name;
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
        final CardController cardController = Get.find();
        cardController.fetchCards(pokemon.name);
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                IconButton(
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: () {
                    final compareController = Get.put(CompareController());

                    compareController.addPokemon(pokemon);
                  },
                ),
              ],
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

                    return Platform.isWindows
                        ? Chip(
                          label: Text(
                            typeName.capitalize!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: color,
                        )
                        : Chip(
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: -2,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
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
