import 'package:pokemonapp/data/models/evolution_chain.dart';
import 'package:pokemonapp/data/models/pokemon_species.dart';
import 'package:pokemonapp/data/providers/poke_api_provider.dart';

import '../models/pokemon_list_response.dart';
import '../models/pokemon_detail.dart';

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

  Future<PokemonDetail> getPokemonDetail(String name) {
    return _provider.fetchPokemonDetailByName(name.toLowerCase());
  }

  Future<PokemonSpecies> getPokemonSpecies(String name) {
    return _provider.fetchPokemonSpecies(name);
  }

  Future<EvolutionChainResponse> getEvolutionChain(String url) {
    return _provider.fetchEvolutionChain(url);
  }

  Future<Map<String, dynamic>> getTypeWeakness(String type) {
    return _provider.fetchType(type);
  }
}
