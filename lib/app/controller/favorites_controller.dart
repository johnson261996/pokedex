import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';

class FavoritesController extends GetxController {
  var favoriteList = <PokemonDetail>[].obs;
  final favoritesBox = Hive.box('favorites');

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  void toggleFavorite(PokemonDetail pokemon) {
    if (isFavorite(pokemon)) {
      favoriteList.removeWhere((p) => p.id == pokemon.id);
    } else {
      favoriteList.add(pokemon);
    }
    favoritesBox.put('pokemon_list', favoriteList);
  }

  void loadFavorites() {
    final list = favoritesBox.get(
      'pokemon_list',
      defaultValue: <PokemonDetail>[],
    );
    favoriteList.assignAll(list.cast<PokemonDetail>());
  }

  bool isFavorite(PokemonDetail pokemon) {
    return favoriteList.any((p) => p.id == pokemon.id);
  }
}
