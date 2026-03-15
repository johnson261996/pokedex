import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';
import 'package:pokemonapp/data/repository/pokemon_repository.dart';

class CardController extends GetxController {

  final PokemonRepository repository = PokemonRepository();

  var cards = <TcgCard>[].obs;
  var cardDetail = Rxn<TcgCardDetail>();
  var isLoading = false.obs;

  Future<void> fetchCards(String pokemonName) async {
    isLoading.value = true;

    final result = await repository.getCards(pokemonName);

    cards.value = result;

    isLoading.value = false;
  }

  Future<bool> fetchCardDetail(String cardId) async {
    isLoading.value = true;

    try {
      final result = await repository.getCardDetail(cardId);
      cardDetail.value = result;
      return true;
    } on DioError catch (e) {
      // Handle expected 404 / not found cases gracefully.
      if (e.response?.statusCode == 404) {
        cardDetail.value = null;
        return false;
      }

      // For other Dio errors (network, parsing, etc.) we log and return false.
      cardDetail.value = null;
      return false;
    } catch (_) {
      cardDetail.value = null;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}