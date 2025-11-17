import 'package:get/get.dart';
import 'package:pokemonapp/app/controller/detail_controller.dart';


class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
