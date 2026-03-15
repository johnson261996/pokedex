class TcgCard {
  final String id;
  final String name;
  final String image;

  TcgCard({required this.id, required this.name, required this.image});

  String get imageUrl => "$image/high.webp";

  factory TcgCard.fromJson(Map<String, dynamic> json) {
    return TcgCard(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }
}

class TcgCardDetail {
  final String name;
  final String image;
  final String? id;
  final int? hp;
  final List<String>? types;
  final List attacks;
  final List weaknesses;
  final int? retreat;
  final String? rarity;
  final String? illustrator;
  final String? set;

  TcgCardDetail({
    required this.name,
    required this.image,
    this.id,
    this.hp,
    this.types,
    required this.attacks,
    required this.weaknesses,
    this.retreat,
    this.rarity,
    this.illustrator,
    this.set,
  });

  String get imageUrl => "$image/high.webp";

  factory TcgCardDetail.fromJson(Map<String,dynamic> json){
    return TcgCardDetail(
      name: json["name"],
      image: json["image"] ?? "",
      id: json["id"],
      hp: json["hp"],
      types: json["types"]?.cast<String>(),
      attacks: json["attacks"] ?? [],
      weaknesses: json["weaknesses"] ?? [],
      retreat: json["retreat"],
      rarity: json["rarity"],
      illustrator: json["illustrator"],
      set: json["set"]?["name"],
    );
  }
}
