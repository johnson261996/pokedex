import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/data/models/pokemon_list_response.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

class FakePokemonRepository extends PokemonRepository {
  @override
  Future<PokemonListResponse> getPokemonList({
    int limit = 100,
    int offset = 0,
    String query = '',
  }) async {
    return PokemonListResponse(
      results: [
        PokemonListItem(
          name: 'pikachu',
          url: 'https://pokeapi.co/api/v2/pokemon/25/',
        ),
        PokemonListItem(
          name: 'pidgey',
          url: 'https://pokeapi.co/api/v2/pokemon/16/',
        ),
        PokemonListItem(
          name: 'bulbasaur',
          url: 'https://pokeapi.co/api/v2/pokemon/1/',
        ),
      ],
    );
  }
}

void main() {
  test(
    'search suggestions appear when a query matches pokemon names',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      final controller = HomeController(repository: FakePokemonRepository());

      await controller.fetchAllPokemonNames();
      expect(controller.allPokemonList, isNotEmpty);

      controller.updateSuggestions('pi');

      expect(controller.showSuggestions.value, isTrue);
      expect(controller.suggestions, isNotEmpty);
      expect(controller.suggestions.first['name'], 'pikachu');

      controller.updateSuggestions('');
      expect(controller.showSuggestions.value, isFalse);
    },
  );
}
