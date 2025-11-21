import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokemonapp/data/models/pokemon_detail.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonDetailAdapter());
  Hive.registerAdapter(PokemonStatAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());
  Hive.registerAdapter(PokemonAbilityAdapter());
  await Hive.openBox('settings');
  await Hive.openBox('favorites');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');
    final isDark = settingsBox.get('dark', defaultValue: false);

    return GetMaterialApp(
      title: 'Pokémon App',
      initialRoute: Routes.HOME,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
