class Ability {
  final int id;
  final String name;
  final String description;

  Ability({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    // Find the English effect entry
    final effectEntries = json['effect_entries'] as List<dynamic>;
    String description = '';
    
    for (var entry in effectEntries) {
      if (entry['language']['name'] == 'en') {
        description = entry['effect'];
        break;
      }
    }

    return Ability(
      id: json['id'],
      name: json['name'],
      description: description,
    );
  }
}