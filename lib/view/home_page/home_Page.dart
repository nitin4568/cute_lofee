import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofeee/resource/components/home_widget.dart';
import 'package:lofeee/resource/components/library_widget.dart';
import 'package:lofeee/resource/components/like_widget.dart';
import 'package:lofeee/resource/components/mini_song_widget.dart';
import 'package:lofeee/resource/components/nav_bar.dart';
import 'package:lofeee/resource/widgets/search_widgets.dart';
import 'package:lofeee/view_models/controller/home_controller/home_controller.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final MusicController musicController = Get.find<MusicController>();

  final List<Widget> screens = [
    HomeWidget(),
    SearchWidget(),
    LibraryWidget(),
    LikesWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          Obx(() {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h), // 🔥 space for mini player
              child: screens[controller.selectedIndex.value],
            );
          }),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}