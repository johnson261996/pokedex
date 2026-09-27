import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapp/app/views/home_view.dart';

void main() {
  test(
    'platform guard should not use Windows layout on non-Windows targets',
    () {
      expect(
        HomeViewPlatform.useWindowsLayout,
        defaultTargetPlatform == TargetPlatform.windows && !kIsWeb
            ? isTrue
            : isFalse,
      );
    },
  );
}
