import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../resource/theam/sellect.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [

          SizedBox(height: 20.h),

          /// 🎨 THEME
          _buildTile(
            context: context,
            icon: Icons.color_lens,
            title: "Themes",
            subtitle: "Change app appearance",
            onTap: () {
              Get.to(() => ThemeSelectionScreen());
            },
          ),

          /// ℹ️ ABOUT
          _buildTile(
            context: context,
            icon: Icons.info,
            title: "About",
            subtitle: "App version & info",
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: theme.cardColor,
                  title: Text(
                    "About App",
                    style: theme.textTheme.titleMedium,
                  ),
                  content: Text(
                    "Lofeee 🎧\n"
                        "Version 1.0.0\n\n"
                        "Developed by: Nitin Gautam\n"
                        "Email: nkgautam1450@gmail.com",
                    style: theme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 REUSABLE TILE
  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
        ),

        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall,
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.iconTheme.color,
        ),

        onTap: onTap,
      ),
    );
  }
}