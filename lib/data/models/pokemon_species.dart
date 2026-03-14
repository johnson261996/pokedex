class PokemonSpecies {
  final EvolutionChain evolutionChain;
  final String description;
  final String category;

  PokemonSpecies({required this.evolutionChain, required this.description, required this.category});

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    // extract English description
    String desc = "";
    for (var entry in json["flavor_text_entries"]) {
      if (entry["language"]["name"] == "en") {
        desc = entry["flavor_text"];
        break;
      }
    }

    // extract English category (genus)
    String category = "";
    for (var entry in json["genera"]) {
      if (entry["language"]["name"] == "en") {
        category = entry["genus"];
        break;
      }
    }

    // clean weird characters like \n and \f
    desc = desc.replaceAll("\n", " ").replaceAll("\f", " ");
    return PokemonSpecies(
      evolutionChain: EvolutionChain.fromJson(json["evolution_chain"]),
      description: desc,
      category: category,
    );
  }
}

class EvolutionChain {
  final String url;

  EvolutionChain({required this.url});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(url: json["url"]);
  }
}
