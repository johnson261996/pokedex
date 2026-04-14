import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';

class CompareController extends GetxController {
  var selectedPokemons = <PokemonDetail>[].obs;
  late Box<List> selectedPokemonsBox;

  @override
  void onInit() {
    super.onInit();
    selectedPokemonsBox = Hive.box<List>('selectedPokemons');
    loadSelectedPokemons();
    ever(selectedPokemons, (_) => saveSelectedPokemons());
  }

  void loadSelectedPokemons() {
    final stored = selectedPokemonsBox.get('pokemons', defaultValue: []);
    if (stored != null) {
      selectedPokemons.assignAll(stored.cast<PokemonDetail>());
    }
  }

  void saveSelectedPokemons() {
    selectedPokemonsBox.put('pokemons', selectedPokemons.toList());
  }

  void addPokemon(PokemonDetail pokemon) {
    if (!selectedPokemons.any((p) => p.id == pokemon.id)) {
      selectedPokemons.add(pokemon);
      Get.snackbar(
        "Added",
        "${pokemon.translatedName.isNotEmpty ? pokemon.translatedName : pokemon.name} added for comparison",
        duration: const Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        "Already Added",
        "${pokemon.translatedName.isNotEmpty ? pokemon.translatedName : pokemon.name} is already added for comparison",
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removePokemon(int id) {
    selectedPokemons.removeWhere((p) => p.id == id);
  }

  void clearAll() {
    selectedPokemons.clear();
  }
}
