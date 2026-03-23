import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSnackbar {

  static void _show({
    required String title,
    required String message,
    required Color bgColor,
    required IconData icon,
    int duration = 2,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(12.w),
      borderRadius: 12.r,
      duration: Duration(seconds: duration),

      icon: Icon(icon, color: Colors.white, size: 24.sp),

      titleText: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.white,
        ),
      ),

      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
    );
  }

  static void success(String message) {
    _show(
      title: "Success",
      message: message,
      bgColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void error(String message) {
    _show(
      title: "Error",
      message: message,
      bgColor: Colors.red,
      icon: Icons.error,
      duration: 3,
    );
  }

  static void info(String message) {
    _show(
      title: "Info",
      message: message,
      bgColor: Colors.blue,
      icon: Icons.info,
    );
  }
}