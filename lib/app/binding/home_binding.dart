import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/card_controller.dart';
import 'package:pokemonapp/app/controller/compare_controller.dart';
import 'package:pokemonapp/app/controller/favorites_controller.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/app/controller/navigation_controller.dart';
import 'package:pokemonapp/app/controller/network_controller.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';
import 'package:pokemonapp/app/controller/theme_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
    Get.put(NavigationController());
    Get.put(NetworkController());
    Get.put(FavoritesController());
    Get.put(CompareController());
    Get.put(CardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(ThemeController());
  }
}
