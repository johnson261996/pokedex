import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';

class FavoritesController extends GetxController {
  var favoriteList = <PokemonDetail>[].obs;
  final favoritesBox = Hive.box('favorites');
    final HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  void toggleFavorite(PokemonDetail pokemon)async {
    if (isFavorite(pokemon)) {
      favoriteList.removeWhere((p) => p.id == pokemon.id);
    } else {

      final bytes = await downloadImage(pokemon.imageUrl);
      pokemon.imageBytes = bytes;
      favoriteList.add(pokemon);
        Get.snackbar(
        "Added",
        "${pokemon.name} added for Favorites",
        duration: const Duration(seconds: 1),
      );
    }
    favoritesBox.put('pokemon_list', favoriteList);
  }


Future<Uint8List?> downloadImage(String url) async {
  try {
    final dio = Dio();

    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes), // ✅ IMPORTANT
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data); // ✅ convert properly
    }
  } catch (e) {
    print("Image download error: $e");
  }

  return null;
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

  void clearAll(){
    favoriteList.clear()
    ;
  }
}
