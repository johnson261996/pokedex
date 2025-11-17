class PokemonListResponse {

  final List<NamedAPIResource> results;

  PokemonListResponse({

    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(

      results: List<NamedAPIResource>.from(
        json['results'].map((x) => NamedAPIResource.fromJson(x))
      ),
    );
  }

    /// Handle single Pokémon search result
  factory PokemonListResponse.fromSingle(Map<String, dynamic> json) {
    return PokemonListResponse(
      results: [
        NamedAPIResource(
          name: json['name'],
          url: "https://pokeapi.co/api/v2/pokemon/${json['id']}/",
        ),
      ],
    );
  }
}

class NamedAPIResource {
  final String name;
  final String url;
  NamedAPIResource({ required this.name, required this.url });

  factory NamedAPIResource.fromJson(Map<String, dynamic> json) {
    return NamedAPIResource(
      name: json['name'],
      url: json['url'],
    );
  }
}
