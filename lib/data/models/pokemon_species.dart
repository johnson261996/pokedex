class PokemonSpecies {
  final EvolutionChain evolutionChain;
  final String description;
  final String category;
  final Map<String, String> names; // language code -> name

  PokemonSpecies({
    required this.evolutionChain,
    required this.description,
    required this.category,
    required this.names,
  });

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

    // extract names in different languages
    Map<String, String> names = {};
    for (var entry in json["names"]) {
      final lang = entry["language"]["name"];
      final name = entry["name"];
      names[lang] = name;
    }

    // clean weird characters like \n and \f
    desc = desc.replaceAll("\n", " ").replaceAll("\f", " ");
    return PokemonSpecies(
      evolutionChain: EvolutionChain.fromJson(json["evolution_chain"]),
      description: desc,
      category: category,
      names: names,
    );
  }

  String getTranslatedName(String languageCode) {
    if (names.containsKey(languageCode)) {
      return names[languageCode]!;
    }
    // Fallback to English if available
    if (names.containsKey('en')) {
      return names['en']!;
    }
    // Fallback to any available name
    if (names.isNotEmpty) {
      return names.values.first;
    }
    // Ultimate fallback - should not happen
    return '';
  }
  }


class EvolutionChain {
  final String url;

  EvolutionChain({required this.url});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(url: json["url"]);
  }
}
