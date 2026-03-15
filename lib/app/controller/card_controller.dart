import 'package:get/get.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

class CardController extends GetxController {

  final PokemonRepository repository = PokemonRepository();

  var cards = <TcgCard>[].obs;
  var cardDetail = Rxn<TcgCardDetail>();
  var isCardLoading = false.obs;
    var isCardDetailLoading = false.obs;

  Future<void> fetchCards(String pokemonName) async {
    isCardLoading.value = true;

    final result = await repository.getCards(pokemonName);

    cards.value = result;

    isCardLoading.value = false;
  }

  Future<bool> fetchCardDetail(String cardId) async {
    isCardDetailLoading.value = true;

    try {
      final result = await repository.getCardDetail(cardId);
      cardDetail.value = result;
      return true;
    }  catch (_) {
      cardDetail.value = null;
      return false;
    } finally {
      isCardDetailLoading.value = false;
    }
  }

}