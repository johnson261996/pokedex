import 'package:flutter/material.dart';

class PokemonCardColor {
  static Color get(String? color) {
    switch (color?.toLowerCase()) {
      case 'black':
        return const Color(0xFF4A4A4A);

      case 'blue':
        return const Color(0xFF4A90E2);

      case 'brown':
        return const Color(0xFF9A6A42);

      case 'gray':
        return const Color(0xFF8A8A8A);

      case 'green':
        return const Color(0xFF63B96B);

      case 'pink':
        return const Color(0xFFE98BAA);

      case 'purple':
        return const Color(0xFF9B70C9);

      case 'red':
        return const Color(0xFFE85D5D);

      case 'white':
        return const Color(0xFFEFEFEF);

      case 'yellow':
        return const Color(0xFFF2C94C);

      default:
        return const Color(0xFF9E9E9E);
    }
  }

  static Color darken(Color color, [double amount = .15]) {
    final hsl = HSLColor.fromColor(color);

    return hsl
        .withLightness(
          (hsl.lightness - amount).clamp(0.0, 1.0),
        )
        .toColor();
  }

  static Color lighten(Color color, [double amount = .15]) {
    final hsl = HSLColor.fromColor(color);

    return hsl
        .withLightness(
          (hsl.lightness + amount).clamp(0.0, 1.0),
        )
        .toColor();
  }
}