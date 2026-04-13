import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/navigation_controller.dart';
import 'package:pokemonapp/app/views/compare_view.dart';
import 'package:pokemonapp/app/views/fav_view.dart';
import 'package:pokemonapp/app/views/settings_view.dart';
import 'home_view.dart';

class HomeWrapperView extends StatelessWidget {
  const HomeWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: [
            HomeView(),
            CompareView(),
            FavoritesView(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare),
              label: "Compare",
            ),
            BottomNavigationBarItem(
              label: "Favorites",
              icon: Icon(Icons.favorite),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
