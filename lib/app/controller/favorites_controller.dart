import 'package:get/get.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';

class FavoritesController extends GetxController {
  var favoriteList = <PokemonDetail>[].obs;

  void toggleFavorite(PokemonDetail pokemon) {
    if (isFavorite(pokemon)) {
      favoriteList.removeWhere((p) => p.id == pokemon.id);
    } else {
      favoriteList.add(pokemon);
    }
  }

  bool isFavorite(PokemonDetail pokemon) {
    return favoriteList.any((p) => p.id == pokemon.id);
  }
}
