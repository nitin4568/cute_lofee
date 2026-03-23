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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          currentIndex: selectedIndex,
          onTap: controller.changeIndex,

          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,

          selectedFontSize: 12.sp,
          unselectedFontSize: 11.sp,

          items: [
            _buildItem(Icons.home, "Home", 0, selectedIndex),
            _buildItem(Icons.search, "Search", 1, selectedIndex),
            _buildItem(Icons.library_music, "Library", 2, selectedIndex),
            _buildItem(Icons.favorite, "Likes", 3, selectedIndex),
          ],
        ),
      );
    });
  }

  BottomNavigationBarItem _buildItem(
      IconData icon, String label, int index, int selectedIndex) {

    final isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.pink.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: isSelected ? 26.sp : 22.sp,
        ),
      ),
      label: label,
    );
  }
}