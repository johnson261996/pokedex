class PokemonListResponse {
  final List<PokemonListItem> results;

  PokemonListResponse({required this.results});

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      results: List<PokemonListItem>.from(
        json['results'].map((x) => PokemonListItem.fromJson(x)),
      ),
    );
  }

  /// Handle single Pokémon search result
  factory PokemonListResponse.fromSingle(Map<String, dynamic> json) {
    return PokemonListResponse(
      results: [
        PokemonListItem(
          name: json['name'],
          url: "https://pokeapi.co/api/v2/pokemon/${json['id']}/",
        ),
      ],
    );
  }
}

class PokemonListItem {
  final String name;
  final String url;
  PokemonListItem({required this.name, required this.url});

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(name: json['name'], url: json['url']);
  }
}
