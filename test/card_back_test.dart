import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapp/app/views/component/card_back.dart';
import 'package:pokemonapp/data/models/tcg_card.dart';

void main() {
  testWidgets('set symbol image uses the API URL without appending .png', (
    tester,
  ) async {
    final card = TcgCardDetail(
      name: 'Pikachu',
      image: 'https://assets.tcgdex.net/en/me/me01/001',
      localId: '001',
      hp: 60,
      types: const ['Lightning'],
      attacks: const [],
      weaknesses: const [],
      abilities: const [],
      resistances: const [],
      retreat: 0,
      setName: 'Mega Evolution',
      setId: 'me01',
      setLogo: 'https://assets.tcgdex.net/en/me/me01/logo',
      setSymbol: 'https://assets.tcgdex.net/univ/me/me01/symbol',
      setOfficialCards: 12,
      rarity: 'Rare',
      illustrator: 'Ken Sugimori',
    );

    final widget = CardBack(card: card);

    expect(
      widget.setSymbolUrl,
      equals('https://assets.tcgdex.net/univ/me/me01/symbol'),
    );
  });
}
