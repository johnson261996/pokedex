import 'package:get/get.dart';
import 'package:pokemonapp/app/binding/detail_binding.dart';
import 'package:pokemonapp/app/binding/fav_binding.dart';
import 'package:pokemonapp/app/binding/home_binding.dart';
import 'package:pokemonapp/app/views/fav_view.dart';
import 'package:pokemonapp/app/views/home_wrapper_view.dart';
import '../views/detail_view.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeWrapperView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => DetailView(),
      binding: DetailBinding(),
     ),
        GetPage(
      name: Routes.FAVOURITE,
      page: () => FavoritesView(),
      binding: FavoritesBinding(),
    )
  ];
}
