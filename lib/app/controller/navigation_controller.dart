import 'package:get/get.dart';
import 'package:pokemonapp/app/views/fav_view.dart';
import 'package:pokemonapp/app/views/home_view.dart';

class NavigationController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    if(tabIndex.value == 0){
      HomeView();
    }else{
      FavoritesView();
    }
  }
}
