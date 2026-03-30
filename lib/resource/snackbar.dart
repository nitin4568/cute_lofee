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

    final context = Get.context!;
    final theme = Theme.of(context);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: theme.colorScheme.onPrimary,
      margin: EdgeInsets.all(12.w),
      borderRadius: 12.r,
      duration: Duration(seconds: duration),

      icon: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
        size: 24.sp,
      ),

      titleText: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),

      messageText: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),

      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
    );
  }

  /// ✅ SUCCESS
  static void success(String message) {
    final theme = Theme.of(Get.context!);

    _show(
      title: "Success",
      message: message,
      bgColor: theme.colorScheme.primary,
      icon: Icons.check_circle,
    );
  }

  /// ❌ ERROR
  static void error(String message) {
    final theme = Theme.of(Get.context!);

    _show(
      title: "Error",
      message: message,
      bgColor: theme.colorScheme.error,
      icon: Icons.error,
      duration: 3,
    );
  }

  /// ℹ️ INFO
  static void info(String message) {
    final theme = Theme.of(Get.context!);

    _show(
      title: "Info",
      message: message,
      bgColor: theme.colorScheme.secondary,
      icon: Icons.info,
    );
  }
}