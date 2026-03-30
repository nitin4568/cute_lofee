import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../resource/theam/theam_controller.dart';
import '../../resource/theam/theam_type.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() =>
      _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {

  final ThemeService themeService = Get.find<ThemeService>();

  Color selectedBg = Colors.black;
  Color selectedBtn = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text("Select Theme 🎨"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),

        child: Column(
          children: [

            /// 🔥 GRID
            Expanded(
              child: Obx(() {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,

                  children: AppThemeType.values.map((type) {
                    return _themeCard(context, type);
                  }).toList(),
                );
              }),
            ),

            /// 🎨 CUSTOM BUTTON
            ElevatedButton(
              onPressed: () {
                _openCustomDialog();
              },
              child: const Text("Custom Theme 🎨"),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 THEME CARD
  Widget _themeCard(BuildContext context, AppThemeType type) {
    final theme = Theme.of(context);
    final isSelected = themeService.themeType == type;

    Color color;

    switch (type) {
      case AppThemeType.system:
        color = Colors.grey;
        break;

      case AppThemeType.pink:
        color = Colors.pink;
        break;

      case AppThemeType.blackWhite:
        color = Colors.black;
        break;

      case AppThemeType.ben10:
        color = const Color(0xFF00FF00);
        break;
      case AppThemeType.pikachu:
        color = Colors.yellow;
        break;

      case AppThemeType.custom:
        color = Colors.blue;
        break;

      case AppThemeType.system:
        // TODO: Handle this case.
        throw UnimplementedError();

        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return GestureDetector(
      onTap: () {
        if (type == AppThemeType.custom) {
          _openCustomDialog();
        } else {
          themeService.changeTheme(type);
        }
      },

      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16.r),

          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),

        child: Stack(
          children: [

            /// 🎨 CIRCLE
            Center(
              child: Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// ✅ TICK
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle),
              ),

            /// NAME
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                type.name.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 CUSTOM COLOR PICKER DIALOG
  void _openCustomDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Pick Colors 🎨"),

          content: SingleChildScrollView(
            child: Column(
              children: [

                const Text("Background Color"),
                ColorPicker(
                  pickerColor: selectedBg,
                  onColorChanged: (color) {
                    selectedBg = color;
                  },
                ),

                const SizedBox(height: 10),

                const Text("Button Color"),
                ColorPicker(
                  pickerColor: selectedBtn,
                  onColorChanged: (color) {
                    selectedBtn = color;
                  },
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                themeService.setCustomTheme(
                    selectedBg, selectedBtn);

                Get.back();
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }
}