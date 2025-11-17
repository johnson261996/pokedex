class EvolutionChainResponse {
  final EvolutionNode chain;

  EvolutionChainResponse({required this.chain});

  factory EvolutionChainResponse.fromJson(Map<String, dynamic> json) {
    return EvolutionChainResponse(
      chain: EvolutionNode.fromJson(json["chain"]),
    );
  }
}

class EvolutionNode {
  final String speciesName;
  final List<EvolutionNode> evolvesTo;

  EvolutionNode({required this.speciesName, required this.evolvesTo});

  factory EvolutionNode.fromJson(Map<String, dynamic> json) {
    return EvolutionNode(
      speciesName: json["species"]["name"],
      evolvesTo: (json["evolves_to"] as List)
          .map((e) => EvolutionNode.fromJson(e))
          .toList(),
    );
  }
}
