import 'package:get/get.dart';
import 'package:pokemonapp/app/binding/detail_binding.dart';
import 'package:pokemonapp/app/binding/fav_binding.dart';
import 'package:pokemonapp/app/binding/home_binding.dart';
import 'package:pokemonapp/app/controller/settings_controller.dart';
import 'package:pokemonapp/app/views/fav_view.dart';
import 'package:pokemonapp/app/views/home_wrapper_view.dart';
import '../views/detail_view.dart';

part 'app_routes.dart';

class AppPages {
  static List<GetPage> get pages {
    final settings = Get.find<SettingsController>();
    return [
      GetPage(
        name: Routes.HOME,
        page: () => HomeWrapperView(),
        transition:
            settings.animationsEnabled.value
                ? Transition.fade
                : Transition.noTransition,
        binding: HomeBinding(),
      ),
      GetPage(
        name: Routes.DETAIL,
        page: () => DetailView(),
        transition:
            settings.animationsEnabled.value
                ? Transition.fade
                : Transition.noTransition,
        binding: DetailBinding(),
      ),
      GetPage(
        name: Routes.FAVOURITE,
        page: () => FavoritesView(),
        transition:
            settings.animationsEnabled.value
                ? Transition.fade
                : Transition.noTransition,
        binding: FavoritesBinding(),
      ),
    ];
  }
}
