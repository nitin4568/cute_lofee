import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:audio_service/audio_service.dart';

import 'package:lofeee/resource/routes/app_routes.dart';
import 'package:lofeee/resource/routes/routs.dart';
import 'package:lofeee/data/binding/app_binding.dart';
import 'package:lofeee/audio_handler.dart';

late MyAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  try {
    audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.lofeee.music',
        androidNotificationChannelName: 'Music Playback',
        androidNotificationOngoing: true,

      ),
    );

    Get.put<MyAudioHandler>(audioHandler, permanent: true);
  } catch (e) {
    print("AudioService ERROR: $e");

    // 🔥 fallback to avoid crash
    Get.put<MyAudioHandler>(MyAudioHandler(), permanent: true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: AppBinding(),
          initialRoute: AppRouteNames.splash,
          getPages: AppRoutes.appRoutes(),
        );
      },
    );
  }
}