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
  final String? localId;
  final int? hp;
  final List<String>? types;
  final List attacks;
  final List weaknesses;
  final List abilities;
  final int? retreat;
  final String? rarity;
  final String? illustrator;
  final String? set;
  final String? evolveFrom;
  final String? stage;
  final List? resistances;
  final String? setName;
  final String? setId;
  final String setLogo;
  final String? setSymbol;
  final int? setTotalCards;
  final int? setOfficialCards;

  TcgCardDetail({
    required this.name,
    required this.image,
    this.id,
    this.localId,
    this.hp,
    this.types,
    required this.attacks,
    required this.weaknesses,
    required this.abilities,
    this.retreat,
    this.rarity,
    this.illustrator,
    this.set,
    this.evolveFrom,
    this.stage,
    this.resistances,
    this.setName,
    this.setId,
    required this.setLogo,
    this.setSymbol,
    this.setTotalCards,
    this.setOfficialCards,
  });

  String get imageUrl => "$image/high.webp";

  factory TcgCardDetail.fromJson(Map<String, dynamic> json) {
    final set = json["set"] ?? {};
    final cardCount = set["cardCount"] ?? {};

    return TcgCardDetail(
      id: json["id"],
      localId: json["localId"],
      name: json["name"],
      image: json["image"],
      rarity: json["rarity"] ?? "",
      illustrator: json["illustrator"] ?? "",

      hp: json["hp"],
      types: json["types"]?.cast<String>(),
      evolveFrom: json["evolveFrom"],
      stage: json["stage"],

      attacks: json["attacks"] ?? [],
      weaknesses: json["weaknesses"] ?? [],
      abilities: json["abilities"] ?? [],
      resistances: json["resistances"] ?? [],

      retreat: json["retreat"],

      // ✅ FIXED HERE
      setName: set["name"] ?? "",
      setId: set["id"] ?? "",
      setLogo: set["logo"] ?? "",
      setSymbol: set["symbol"] ?? "",

      setOfficialCards: cardCount["official"] ?? 0,
      setTotalCards: cardCount["total"] ?? 0,
    );
  }
}
