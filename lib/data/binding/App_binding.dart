import 'package:get/get.dart';
import 'package:lofeee/view_models/controller/home_controller/home_controller.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    /// 🎧 GLOBAL CONTROLLER (PURE APP ME SAME RAHEGA)
    Get.put<MusicController>(
      MusicController(),
      permanent: true,
    );

    /// 🏠 HOME CONTROLLER
    Get.lazyPut<HomeController>(() => HomeController());
  }
}