import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../resource/routes/routs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    await Permission.notification.request();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(AppRouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(

        /// 🎨 THEME BASED GRADIENT BACKGROUND
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.3),
              theme.scaffoldBackgroundColor,
              theme.colorScheme.primary.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🎬 LOTTIE ANIMATION
              Lottie.asset(
                'assets/Happy Spaceman.json',
                width: 200,
                height: 200,
              ),

              SizedBox(height: 20),

              /// 🎧 APP NAME
              Text(
                "Lofeee 🎧",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),

              SizedBox(height: 8),

              /// ✨ TAGLINE
              Text(
                "Feel the Music. Live the Vibe with Nitin.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}