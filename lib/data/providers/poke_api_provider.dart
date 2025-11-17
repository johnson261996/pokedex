import 'package:dio/dio.dart';
import 'package:pokemonapp/data/models/evolution_chain.dart';
import 'package:pokemonapp/data/models/pokemon_species.dart';
import 'package:pokemonapp/utils/constants.dart';
import '../models/pokemon_list_response.dart';
import '../models/pokemon_detail.dart';

class PokeApiProvider {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<PokemonListResponse> fetchPokemonList({
    int limit = 100,
    int offset = 0,
    String query = "",
  }) async {
    if (query.isNotEmpty) {
      // Use the Pokémon search API by name
      final response = await _dio.get('pokemon/$query');
      return PokemonListResponse.fromSingle(response.data);
    }

    final response = await _dio.get(
      'pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return PokemonListResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> fetchType(String type) async {
    final response = await _dio.get("type/$type");
    return response.data;
  }

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    final response = await _dio.get(url);
    return PokemonDetail.fromJson(response.data);
  }

  Future<PokemonDetail> fetchPokemonDetailByName(String name) async {
    final response = await _dio.get('pokemon/$name');
    return PokemonDetail.fromJson(response.data);
  }

  Future<PokemonSpecies> fetchPokemonSpecies(String name) async {
    final response = await _dio.get("pokemon-species/$name");
    return PokemonSpecies.fromJson(response.data);
  }

  Future<EvolutionChainResponse> fetchEvolutionChain(String url) async {
    final response = await Dio().get(url); // full URL
    return EvolutionChainResponse.fromJson(response.data);
  }
}
