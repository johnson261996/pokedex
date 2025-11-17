import 'package:get/get.dart';
import 'package:pokemonapp/data/models/evolution_chain.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

class DetailController extends GetxController {
  final PokemonRepository repository = PokemonRepository();

  var isLoading = true.obs;
  var pokemonDetail = Rxn<PokemonDetail>();
  var errorMessage = ''.obs;
  Rx<PokemonDetail?> pokemon = Rx<PokemonDetail?>(null);
  Map<String, int> evolutionIdMap = {};

  RxList<String> evolutionList = <String>[].obs;
  RxList<String> weaknesses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final String name = Get.arguments as String;
    fetchDetail(name);
    loadPokemon(name);
    loadWeakness(name);
  }

  Future<void> loadPokemon(String name) async {
    pokemon.value = await repository.getPokemonDetail(name);

    // Step 1: Get species info
    final species = await repository.getPokemonSpecies(name);
    print("evolution url:${species.evolutionChain.url}");
    // Step 2: Get evolution chain
    final evoChain = await repository.getEvolutionChain(
      species.evolutionChain.url,
    );
    evolutionList.value = [];
    evolutionIdMap.clear();
    // Step 3: Parse evolution species names
    _parseEvolution(evoChain.chain);
  }

  void _parseEvolution(EvolutionNode node) async {
    evolutionList.add(node.speciesName);

    // fetch ID for image
    final detail = await repository.getPokemonDetail(node.speciesName);
    evolutionIdMap[node.speciesName] = detail.id;

    for (var evo in node.evolvesTo) {
      _parseEvolution(evo);
    }
  }

  void fetchDetail(String name) async {
    try {
      isLoading.value = true;
      final detail = await repository.getPokemonDetail(name);
      pokemonDetail.value = detail;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error loading detail';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadWeakness(String name) async {
    final detail = await repository.getPokemonDetail(name);

    Set<String> weak = {};

    for (var t in detail.types) {
      final typeData = await repository.getTypeWeakness(t.name);

      final damage = typeData["damage_relations"];

      for (var x in damage["double_damage_from"]) {
        weak.add(x["name"]);
      }
    }

    weaknesses.value = weak.toList();
  }
}
