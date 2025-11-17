class Pokemon {
  final String name;
  final String imageUrl;
  final int id;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      imageUrl: json['sprites']['front_default'] ??
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png',
    );
  }
}
