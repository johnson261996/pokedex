import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/data/models/pokemon_list_response.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';
import 'package:pokemonapp/utils/sort_type.dart';

class HomeController extends GetxController {
  final PokemonRepository _repository;

  HomeController({PokemonRepository? repository})
    : _repository = repository ?? PokemonRepository();

  var pokemonList = <PokemonDetail>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var suggestions = <Map<String, dynamic>>[].obs; // 👈 suggestions list
  var allPokemonList = <PokemonListItem>[].obs; // 👈 all names for autocomplete
  int limit = 10;
  int offset = 0;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;
  bool hasMore = true;
  var showSuggestions = false.obs;
  var showClose = false.obs;
  var showRecent = false.obs;
  var sortType = SortType.lowestNumber.obs;
  List<PokemonDetail> pokemonListBackup = [];
  var isFiltering = false.obs;
  bool _reloadAfterCurrentLoad = false;
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
  var recentSearches = <String>[].obs;
   final AudioPlayer _player = AudioPlayer();

  final RxInt playingPokemonId = (-1).obs;
  final RxBool isPlaying = false.obs;

 
  Future<void> playCry(PokemonDetail pokemon) async {
    final url = pokemon.cryLatest ?? pokemon.cryLegacy;

    if (url == null || url.isEmpty) {
      Get.snackbar(
        "Cry unavailable",
        "No cry available for ${pokemon.name.capitalizeFirst}",
      );
      return;
    }

      final playbackUrl =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS
          ? 'https://pokemoncries.com/cries/${pokemon.id}.mp3'
          : url;

    try {
      if (playingPokemonId.value == pokemon.id && isPlaying.value) {
        await _player.stop();
        playingPokemonId.value = -1;
        isPlaying.value = false;
        return;
      }

      await _player.stop();

      playingPokemonId.value = pokemon.id;
      isPlaying.value = true;

      await _player.setUrl(playbackUrl);
      await _player.play();
    } catch (e) {
      playingPokemonId.value = -1;
      isPlaying.value = false;

      Get.snackbar("Cry playback error", "Error playing cry for ${pokemon.name.capitalizeFirst}: $e");
    }
  }

  Future<void> stopCry() async {
    await _player.stop();
    playingPokemonId.value = -1;
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  /// Keeps the first occurrence of each Pokémon. A Pokémon can be reached
  /// through more than one request (for example, random results followed by a
  /// type filter), so the UI should always receive a unique list.
  List<PokemonDetail> _uniquePokemon(Iterable<PokemonDetail> pokemons) {
    final seenIds = <int>{};
    return pokemons.where((pokemon) => seenIds.add(pokemon.id)).toList();
  }

  void _setPokemonList(Iterable<PokemonDetail> pokemons) {
    final uniquePokemon = _uniquePokemon(pokemons);
    pokemonList.assignAll(uniquePokemon);
    pokemonListBackup = List.from(uniquePokemon);
  }

  @override
  void onInit() {
    super.onInit();
  _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playingPokemonId.value = -1;
        isPlaying.value = false;
      }
    });
    // Debounce search input (delay 300 ms)
    debounce(searchQuery, (_) {
      showSuggestions.value = true;
      showRecent.value = true;
      updateSuggestions(searchQuery.value);
    }, time: const Duration(milliseconds: 300));

    fetchAllPokemonNames();

    // Load initial Pokemon list
    fetchPokemonList();
  }

  void removeRecentSearch(String name) {
    recentSearches.remove(name);
  }

  void clearAllRecentSearches() {
    recentSearches.clear();
  }

  void addRecentSearch(String name) {
    // Avoid duplicates, move to top
    recentSearches.remove(name);
    recentSearches.insert(0, name);

    // Limit to last 10 saved searches
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }
  }

  void onRecentSearchSelected(String name) {
    searchPokemon(name);
    showRecent.value = false;
  }

  Future<void> sortPokemon() async {
    final list = pokemonList;
    isFiltering.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
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
    isFiltering.value = false;
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

    pokemonList.assignAll(_uniquePokemon(result));
    hasMore = false;
    sortPokemon(); // Ensure sorting still active
  }

  // Load all Pokémon names for suggestions
  Future<void> fetchAllPokemonNames() async {
    try {
      final response = await _repository.getPokemonList(limit: 1500, offset: 0);
      allPokemonList.value = response.results.map((e) => e).toList();
    } catch (_) {
      // This list is only used for search suggestions. Do not put the main
      // Pokémon list into an error state when this optional request fails.
    }
  }

  String extractId(String url) {
    final parts = url.split('/');
    return parts[parts.length - 2]; // ID is before last slash
  }

  // Update suggestions list as user types
  void updateSuggestions(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    final matches = allPokemonList
        .where((item) {
          final name = item.name.toString().toLowerCase();
          return name.startsWith(trimmedQuery.toLowerCase()) &&
              !name.contains("-mega");
        })
        .take(15)
        .map(
          (item) => {
            "name": item.name,
            "url": item.url,
          },
        )
        .toList();

    suggestions.assignAll(matches);
    showSuggestions.value = suggestions.isNotEmpty;
  }

  /// Load initial Pokémon
  Future<void> fetchPokemonList() async {
    if (isLoading.value) {
      _reloadAfterCurrentLoad = true;
      return;
    }

    try {
      isLoading(true);
      errorMessage.value = '';
      offset = 0;
      hasMore = true;
      pokemonList.clear();
      sortPokemon();
      await _loadPokemon();
    } catch (_) {
      errorMessage.value = 'something went wrong';
    } finally {
      isLoading(false);

      // A connectivity event may have arrived while the previous request was
      // still failing. Run exactly one fresh request after it has finished.
      if (_reloadAfterCurrentLoad) {
        _reloadAfterCurrentLoad = false;
        Future.microtask(fetchPokemonList);
      }
    }
  }

  /// Reloads safely after the network becomes available again.
  Future<void> reloadAfterReconnect() => fetchPokemonList();

  /// Load more Pokémon on scroll end
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;

    try {
      isLoadingMore(true);
      offset += limit;

      await _loadPokemon();
    } catch (_) {
      // Keep already-loaded Pokémon visible if loading the next page fails.
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

    final loadedPokemon = <PokemonDetail>[];
    final existingIds = pokemonList.map((pokemon) => pokemon.id).toSet();

    for (var item in response.results) {
      final detail = await _repository.getPokemonDetail(item.name);
      if (existingIds.add(detail.id)) {
        loadedPokemon.add(detail);
      }
    }

    _setPokemonList([...pokemonList, ...loadedPokemon]);
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
      addRecentSearch(query);

      // Prefix search (startsWith) - filter Pokemon whose names start with query
      final matchedPokemon =
          allPokemonList.where((item) {
            final name = item.name.toString().toLowerCase();
            return name.startsWith(query.toLowerCase()) &&
                !name.contains("-mega");
          }).toList();

      final loadedPokemon = <PokemonDetail>[];
      final loadedIds = <int>{};

      // Fetch details for matched Pokemon
      for (var item in matchedPokemon) {
        final detail = await _repository.getPokemonDetail(item.name);
        if (loadedIds.add(detail.id)) {
          loadedPokemon.add(detail);
        }
      }

      _setPokemonList(loadedPokemon);

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

      final randomIds = <int>{};
      while (randomIds.length < count && randomIds.length < 1025) {
        randomIds.add(random.nextInt(1025) + 1);
      }

      final randomPokemon = <PokemonDetail>[];
      for (final id in randomIds) {
        final detail = await _repository.getPokemonDetail(id.toString());
        randomPokemon.add(detail);
      }

      _setPokemonList(randomPokemon);
    } finally {
      isLoading(false);
    }
  }
}
