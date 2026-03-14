import 'package:get/get.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';

class CompareController extends GetxController {
  var selectedPokemons = <PokemonDetail>[].obs;

  void addPokemon(PokemonDetail pokemon) {
    if (!selectedPokemons.any((p) => p.id == pokemon.id)) {
      selectedPokemons.add(pokemon);
      Get.snackbar(
        "Added",
        "${pokemon.name} added for comparison",
        duration: const Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        "Already Added",
        "${pokemon.name} is already added for comparison",
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
