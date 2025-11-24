import 'dart:math';

import 'package:get/get.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/data/models/pokemon_list_response.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';
import 'package:pokemonapp/utils/sort_type.dart';

class HomeController extends GetxController {
  final PokemonRepository _repository = PokemonRepository();

  var pokemonList = <PokemonDetail>[].obs;
  var searchList = <NamedAPIResource>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var suggestions = <String>[].obs; // 👈 suggestions list
  var allPokemonNames = <String>[].obs; // 👈 all names for autocomplete
  int limit = 20;
  int offset = 0;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;
  bool hasMore = true;
  var showSuggestions = false.obs;
  var sortType = SortType.lowestNumber.obs;
  List<PokemonDetail> pokemonListBackup = [];
  final List<String> allTypes = [
    "normal",
    "fire",
    "water",
    "grass",
    "electric",
    "ice",
    "fighting",
    "poison",
    "ground",
    "flying",
    "psychic",
    "bug",
    "rock",
    "ghost",
    "dragon",
    "dark",
    "steel",
    "fairy",
  ];

  /// Selected Pokémon types for filtering
  var selectedTypeFilter = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemonList();
    fetchAllPokemonNames(); // load names first
    // Debounce search input (delay 300 ms)
    debounce(searchQuery, (_) {
      showSuggestions.value = true;
      updateSuggestions(searchQuery.value);
    }, time: const Duration(milliseconds: 300));
  }

  void sortPokemon() {
    final list = pokemonList;

    switch (sortType.value) {
      case SortType.lowestNumber:
        list.sort((a, b) => a.id.compareTo(b.id));
        break;

      case SortType.highestNumber:
        list.sort((a, b) => b.id.compareTo(a.id));
        break;

      case SortType.aToZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;

      case SortType.zToA:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    pokemonList.refresh(); // 🔥 important
  }

  void clearFilter() {
    selectedTypeFilter.clear();
    fetchPokemonList();
  }

  void applyFilter() {
    // First apply search if exists
    List<PokemonDetail> result = List.from(
      pokemonListBackup,
    ); // stored original list

    if (searchQuery.value.isNotEmpty) {
      result =
          result
              .where((p) => p.name.contains(searchQuery.value.toLowerCase()))
              .toList();
    }

    // Apply type filter if selected
    if (selectedTypeFilter.isNotEmpty) {
      result =
          result.where((pokemon) {
            final pokemonTypes = pokemon.types.map((t) => t.name).toList();
            return selectedTypeFilter.every(
              (selected) => pokemonTypes.contains(selected),
            );
          }).toList();
    }

    pokemonList.assignAll(result);
    hasMore = false;
    sortPokemon(); // Ensure sorting still active
  }

  // Load all Pokémon names for suggestions
  void fetchAllPokemonNames() async {
    try {
      final response = await _repository.getPokemonList(limit: 1500, offset: 0);
      allPokemonNames.value = response.results.map((e) => e.name).toList();
    } catch (e) {
      errorMessage.value = "something went wrong";
    }
  }

  // Update suggestions list as user types
  void updateSuggestions(String query) {
    if (query.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    suggestions.value =
        allPokemonNames
            .where((name) => name.toLowerCase().contains(query.toLowerCase()))
            .take(15) // limit to 10 suggestions
            .toList();
  }

  /// Load initial Pokémon
  Future<void> fetchPokemonList() async {
    if (isLoading.value) return;

    try {
      isLoading(true);
      offset = 0;
      hasMore = true;
      pokemonList.clear();
      sortPokemon();
      await _loadPokemon();
    } finally {
      isLoading(false);
    }
  }

  /// Load more Pokémon on scroll end
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;

    try {
      isLoadingMore(true);
      offset += limit;

      await _loadPokemon();
    } finally {
      isLoadingMore(false);
    }
  }

  /// Core loader function
  Future<void> _loadPokemon() async {
    final response = await _repository.getPokemonList(
      limit: limit,
      offset: offset,
    );

    if (response.results.isEmpty) {
      hasMore = false;
      return;
    }

    for (var item in response.results) {
      final detail = await _repository.getPokemonDetail(item.name);
      pokemonList.add(detail);
      pokemonListBackup = List.from(pokemonList);
    }
  }

  /// Search Pokémon (disables pagination)
  Future<void> searchPokemon(String query) async {
    if (query.isEmpty) {
      fetchPokemonList();
      return;
    }

    try {
      isLoading(true);
      pokemonList.clear();

      final response = await _repository.getPokemonList(query: query);
      if (response.results.isNotEmpty) {
        final detail = await _repository.getPokemonDetail(
          response.results.first.name,
        );
        pokemonList.add(detail);
        pokemonListBackup = List.from(pokemonList);
      }

      hasMore = false; // disable load more during search
    } finally {
      isLoading(false);
    }
  }

  Future<void> getMultipleRandomPokemon(int count) async {
    try {
      isLoading(true);
      hasMore = true;
      pokemonList.clear();

      final random = Random();

      for (int i = 0; i < count; i++) {
        int id = random.nextInt(1025) + 1;
        final detail = await _repository.getPokemonDetail(id.toString());
        pokemonList.add(detail);
        pokemonListBackup = List.from(pokemonList);
      }
    } finally {
      isLoading(false);
    }
  }
}
