import 'package:hive/hive.dart';

part 'pokemon_detail.g.dart'; // Make sure the file name matches your actual file name

@HiveType(typeId: 0) // Unique type ID for PokemonDetail
class PokemonDetail extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int height;
  @HiveField(3)
  final int weight;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String imageUrl;
  @HiveField(6)
  final List<PokemonStat> stats;
  @HiveField(7)
  final List<PokemonType> types;
  @HiveField(8)
  final List<PokemonAbility> abilities;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.url,
    required this.imageUrl,
    required this.stats,
    required this.types,
    required this.abilities,
  });

  // Include the fromJson factory as well if you need it for network requests
  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      url: 'https://pokeapi.co/api/v2/pokemon/${json['id']}/',
      imageUrl:
          json["sprites"]["other"]["official-artwork"]["front_default"] ??
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png',
      stats:
          (json['stats'] as List).map((e) => PokemonStat.fromJson(e)).toList(),
      types: List<PokemonType>.from(
        json['types'].map((x) => PokemonType.fromJson(x)),
      ),
      abilities: List<PokemonAbility>.from(
        json['abilities'].map((x) => PokemonAbility.fromJson(x)),
      ),
    );
  }
}

@HiveType(typeId: 1) // Unique type ID for PokemonStat
class PokemonStat extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(name: json['stat']['name'], baseStat: json['base_stat']);
  }
}

@HiveType(typeId: 2) // Unique type ID for PokemonType
class PokemonType extends HiveObject {
  @HiveField(0)
  final String name;
  PokemonType({required this.name});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['type']['name']);
  }
}

@HiveType(typeId: 3) // Unique type ID for PokemonAbility
class PokemonAbility extends HiveObject {
  @HiveField(0)
  final String name;
  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(name: json['ability']['name']);
  }
}
