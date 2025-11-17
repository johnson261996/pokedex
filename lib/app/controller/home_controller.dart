import 'dart:math';

import 'package:get/get.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/data/models/pokemon_list_response.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchPokemonList();
    fetchAllPokemonNames(); // load names first
    // Debounce search input (delay 300 ms)
    debounce(searchQuery, (_) {
      fetchPokemons();
      showSuggestions.value = true;
      updateSuggestions(searchQuery.value);
    }, time: const Duration(milliseconds: 300));
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

  void fetchPokemons() async {
    try {
      final response = await _repository.getPokemonList(limit: 50, offset: 0);
      searchList.value = response.results;
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
      }
    } finally {
      isLoading(false);
    }
  }
}
