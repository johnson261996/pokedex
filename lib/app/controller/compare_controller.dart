import 'package:get/get.dart';

class CompareController extends GetxController {
  var selectedPokemons = <Map<String, dynamic>>[].obs;

  void addPokemon(Map<String, dynamic> pokemon) {
    if (!selectedPokemons.any((p) => p['id'] == pokemon['id'])) {
      selectedPokemons.add(pokemon);
    }
  }

  void removePokemon(int id) {
    selectedPokemons.removeWhere((p) => p['id'] == id);
  }

  void clearAll() {
    selectedPokemons.clear();
  }
}