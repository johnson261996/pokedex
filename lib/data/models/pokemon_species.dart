class PokemonSpecies {
  final EvolutionChain evolutionChain;

  PokemonSpecies({required this.evolutionChain});

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(
      evolutionChain: EvolutionChain.fromJson(json["evolution_chain"]),
    );
  }
}

class EvolutionChain {
  final String url;

  EvolutionChain({required this.url});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(
      url: json["url"],
    );
  }
}
