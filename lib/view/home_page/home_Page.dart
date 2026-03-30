import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lofeee/resource/components/home_widget.dart';
import 'package:lofeee/resource/components/library_widget.dart';
import 'package:lofeee/resource/components/mini_song_widget.dart';
import 'package:lofeee/resource/components/nav_bar.dart';
import 'package:lofeee/resource/widgets/search_widgets.dart';

import 'package:lofeee/view_models/controller/home_controller/home_controller.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';

import '../../resource/widgets/playlist_details.dart';
import '../../resource/widgets/playlist_widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final MusicController musicController = Get.find<MusicController>();

  final List<Widget> screens = [
    HomeWidget(),
    SearchWidget(),
    LibraryWidget(),
    PlaylistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔥 MAIN BODY
      body: Obx(() {
        return screens[controller.selectedIndex.value];
      }),

      /// 🔥 MINI PLAYER + NAV BAR (IMPORTANT)
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🎧 MINI PLAYER (GLOBAL FIX)
          MiniPlayer(),

          /// 🔻 NAV BAR
          CustomBottomNavbar(),
        ],
      ),
    );
  }
}