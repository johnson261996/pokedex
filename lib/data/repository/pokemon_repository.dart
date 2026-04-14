import 'package:pokemonapp/data/models/evolution_chain.dart';
import 'package:pokemonapp/data/models/pokemon_species.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/data/providers/poke_api_provider.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';

import '../models/pokemon_list_response.dart';
import '../models/pokemon_detail.dart';
import '../models/ability.dart';

class PokemonRepository {
  final PokeApiProvider _provider = PokeApiProvider();

  Future<PokemonListResponse> getPokemonList({
    int limit = 100,
    int offset = 0,
    String query = "",
  }) {
    return _provider.fetchPokemonList(
      limit: limit,
      offset: offset,
      query: query,
    );
  }

  Future<PokemonDetail> getPokemonDetail(String name) async {
    final json = await _provider.fetchPokemonDetailJson(name.toLowerCase());
    final species = await _provider.fetchPokemonSpecies(name.toLowerCase());
    
    String translatedName = json['name']; // default to English
    if (species != null) {
      // Get current language from settings
      try {
        final settingsController = Get.find<SettingsController>();
        final langCode = settingsController.currentLocale.value.languageCode;
        
        // Map app language codes to PokeAPI language codes
        String pokeApiLang = 'en'; // default
        if (langCode == 'es') pokeApiLang = 'es';
        else if (langCode == 'ja') pokeApiLang = 'ja';
        
        translatedName = species.getTranslatedName(pokeApiLang);
        if (translatedName.isEmpty) translatedName = json['name']; // fallback
      } catch (e) {
        // If settings controller not found, use English
        translatedName = json['name'];
      }
    }
    
    return PokemonDetail.fromJson(json, translatedName: translatedName);
  }

  Future<PokemonSpecies?> getPokemonSpecies(String name) {
    return _provider.fetchPokemonSpecies(name);
  }

  Future<EvolutionChainResponse> getEvolutionChain(String url) {
    return _provider.fetchEvolutionChain(url);
  }

  Future<Map<String, dynamic>> getTypeWeakness(String type) {
    return _provider.fetchType(type);
  }

  Future<Ability> getAbility(String name) {
    return _provider.fetchAbility(name);
  }

  Future<List<TcgCard>> getCards(String pokemonName) {
    return _provider.getCards(pokemonName);
  }

  Future<TcgCardDetail> getCardDetail(String cardId) {
    return _provider.getCardDetail(cardId);
  } 
}
