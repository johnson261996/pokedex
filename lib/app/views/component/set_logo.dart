import 'package:flutter/material.dart';

class SetLogo extends StatelessWidget {

  final String setId;

  const SetLogo({super.key, required this.setId});

  @override
  Widget build(BuildContext context) {

    return Image.network(
      "https://assets.tcgdex.net/en/sets/$setId/logo.png",
      height: 40,
    );
  }
}