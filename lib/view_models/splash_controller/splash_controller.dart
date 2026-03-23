// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:placementt/resource/routes/routs.dart';
//
// class SplashServices {
//   final UserController userController = Get.find<UserController>();
//   final UserPreferences userPreferences = UserPreferences();
//
//   /// Call this after splash screen
//   Future<void> navigate() async {
//     // 1️⃣ Show splash for 3 seconds
//     await Future.delayed(const Duration(seconds: 3));
//
//     // 2️⃣ Check login status from storage
//     bool isLoggedIn = userPreferences.getUserLoggedIn();
//
//     if (isLoggedIn) {
//       // Restore saved user data into controller
//       final savedUser = userPreferences.getSavedUser();
//       if (savedUser != null) {
//         userController.updateUser(savedUser);
//       }
//
//       // Navigate to Home and clear previous stack
//       Get.offAllNamed(AppRouteNames.home);
//     } else {
//       // Navigate to Login and clear previous stack
//       Get.offAllNamed(AppRouteNames.login);
//     }
//   }
// }
