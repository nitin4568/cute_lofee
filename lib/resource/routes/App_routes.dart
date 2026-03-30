import 'package:get/get.dart';
import 'package:lofeee/resource/components/library_widget.dart';
import 'package:lofeee/resource/routes/routs.dart';
import 'package:lofeee/resource/widgets/search_widgets.dart';
import 'package:lofeee/view/Splash_screen/Splash_screen.dart';
import 'package:lofeee/view/home_page/home_Page.dart';
import 'package:lofeee/view/track_screen/track_screen.dart';

import '../../view/home_page/settings_page.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [

    GetPage(
        name: AppRouteNames.splash,
        page: () => const SplashScreen(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 250)),

    GetPage(
      name: AppRouteNames.home,
      page: () => HomeScreen(),
    ),

    GetPage(
      name: AppRouteNames.search,
      page: () => SearchWidget(),
    ),

    GetPage(
      name: AppRouteNames.trackscreen,
      page: () => TrackScreen(
        song: Get.arguments,
      ),
    ),

    GetPage(
      name: AppRouteNames.library,
      page: () => LibraryWidget(),
    ),

  ];
}
