import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppLoading {

  static Widget shimmerBox({
    double height = 100,
    double width = double.infinity,
    double radius = 10,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height.h,
        width: width == double.infinity ? double.infinity : width.w,
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }

  static Widget shimmerList({int itemCount = 5}) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return shimmerBox(height: 100);
      },
    );
  }

  static Widget shimmerCircle({double size = 50}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size.h,
        width: size.w,
        margin: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static Widget shimmerText({
    double width = 100,
    double height = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height.h,
        width: width.w,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        color: Colors.white,
      ),
    );
  }
}