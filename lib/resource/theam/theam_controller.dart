import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lofeee/resource/theam/theam.dart';
import 'package:lofeee/resource/theam/theam_type.dart';

class ThemeService extends GetxService {
  final box = GetStorage();

  final String themeKey = "theme";
  final String bgKey = "custom_bg";
  final String btnKey = "custom_btn";

  final Rx<AppThemeType> _themeType = AppThemeType.system.obs; // 🔥 default system

  AppThemeType get themeType => _themeType.value;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() {
    String? saved = box.read(themeKey);

    if (saved != null) {
      _themeType.value =
          AppThemeType.values.firstWhere((e) => e.name == saved);
    } else {
      _themeType.value = AppThemeType.system;
    }

    applyTheme();
  }

  void changeTheme(AppThemeType type) {
    _themeType.value = type;
    box.write(themeKey, type.name);
    applyTheme();
  }

  // 🔥 CUSTOM COLOR SAVE
  void setCustomTheme(Color bgColor, Color buttonColor) {
    box.write(bgKey, bgColor.value);
    box.write(btnKey, buttonColor.value);

    changeTheme(AppThemeType.custom);
  }

  void applyTheme() {
    switch (_themeType.value) {

    /// 🔥 SYSTEM
      case AppThemeType.system:
        Get.changeThemeMode(ThemeMode.system);
        break;

    /// 💗 PINK
      case AppThemeType.pink:
        Get.changeTheme(AppThemes.pinkTheme);
        Get.changeThemeMode(ThemeMode.light);
        break;

    /// ⚫ BLACK WHITE
      case AppThemeType.blackWhite:
        Get.changeTheme(AppThemes.blackWhiteTheme);
        Get.changeThemeMode(ThemeMode.dark);
        break;

    /// 💚 BEN10 (FIXED 🔥)
      case AppThemeType.ben10:
        Get.changeTheme(AppThemes.ben10Theme);
        Get.changeThemeMode(ThemeMode.light); // 🔥 IMPORTANT
        break;

    /// ⚡ PIKACHU
      case AppThemeType.pikachu:
        Get.changeTheme(AppThemes.pikachuTheme);
        Get.changeThemeMode(ThemeMode.light);
        break;

    /// 🎨 CUSTOM
      case AppThemeType.custom:
        final bgColor =
        Color(box.read(bgKey) ?? Colors.black.value);
        final btnColor =
        Color(box.read(btnKey) ?? Colors.blue.value);

        Get.changeTheme(AppThemes.customTheme(bgColor, btnColor));
        Get.changeThemeMode(ThemeMode.light);
        break;
    }
  }

  }