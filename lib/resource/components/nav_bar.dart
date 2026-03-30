import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../view_models/controller/home_controller/home_controller.dart';

class CustomBottomNavbar extends StatelessWidget {
  CustomBottomNavbar({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 8.r,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor,

          currentIndex: selectedIndex,
          onTap: controller.changeIndex,

          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor:
          Theme.of(context).unselectedWidgetColor,

          selectedFontSize: 12.sp,
          unselectedFontSize: 11.sp,

          items: [
            _buildItem(context, Icons.home, "Home", 0, selectedIndex),
            _buildItem(context, Icons.search, "Search", 1, selectedIndex),
            _buildItem(context, Icons.library_music, "Library", 2, selectedIndex),
            _buildItem(context, Icons.playlist_add, "Playlist", 3, selectedIndex),
          ],
        ),
      );
    });
  }

  BottomNavigationBarItem _buildItem(
      BuildContext context,
      IconData icon,
      String label,
      int index,
      int selectedIndex,
      ) {
    final isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: isSelected ? 27.sp : 25.sp,
        ),
      ),
      label: label,
    );
  }
}