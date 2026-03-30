import 'package:get/get.dart';
import 'package:lofeee/view_models/controller/home_controller/home_controller.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';

import '../../resource/theam/theam_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    /// 🎧 GLOBAL MUSIC CONTROLLER
    Get.put<MusicController>(
      MusicController(),
      permanent: true,
    );

    /// 🎨 THEME SERVICE (GLOBAL 🔥)
    Get.put<ThemeService>(
      ThemeService(),
      permanent: true,
    );

    /// 🏠 HOME CONTROLLER
    Get.lazyPut<HomeController>(() => HomeController());
  }
}