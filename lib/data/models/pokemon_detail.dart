class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String url;
    final String imageUrl;
  final List<PokemonType> types;
  final List<PokemonAbility> abilities;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.url,
        required this.imageUrl,

    required this.types,
    required this.abilities,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
       url: 'https://pokeapi.co/api/v2/pokemon/${json['id']}/',
        imageUrl: json["sprites"]["other"]["official-artwork"]["front_default"] ??
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png',
      types: List<PokemonType>.from(
         json['types'].map((x) => PokemonType.fromJson(x))
      ),
      abilities: List<PokemonAbility>.from(
         json['abilities'].map((x) => PokemonAbility.fromJson(x))
      ),
    );
  }
}

class PokemonType {
  final String name;
  PokemonType({ required this.name });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      name: json['type']['name'],
    );
  }
}

class PokemonAbility {
  final String name;
  PokemonAbility({ required this.name });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['ability']['name'],
    );
  }
}
