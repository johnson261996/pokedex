import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/favorites_controller.dart';
import 'package:pokemonapp/app/controller/home_controller.dart';
import 'package:pokemonapp/app/controller/navigation_controller.dart';
import 'package:pokemonapp/app/controller/network_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    Get.put(NetworkController());
    Get.put(FavoritesController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
