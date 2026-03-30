import 'package:flutter/material.dart';

class AppThemes {

  // 💗 Pink
  static final pinkTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Colors.pink,
      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.pink,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // ⚫ Black White
  static final blackWhiteTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,

    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    ),
  );

  // 💚 Ben10 (Black + Neon Green)
  static final ben10Theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00FF00), // neon green 🔥
      onPrimary: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF00FF00),
      foregroundColor: Colors.black,
    ),

    iconTheme: const IconThemeData(color: Color(0xFF00FF00)),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00FF00),
        foregroundColor: Colors.black,
      ),
    ),
  );


  // ⚡ Pikachu (Yellow + Black)
  static final pikachuTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFFFEB3B),

    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.yellow,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.yellow,
    ),

    iconTheme: const IconThemeData(color: Colors.black),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
    ),
  );

  // 🎨 Custom Theme
  static ThemeData customTheme(Color bg, Color btn) {
    return ThemeData(
      scaffoldBackgroundColor: bg,

      colorScheme: ColorScheme.light(
        primary: btn,
        onPrimary: Colors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: btn,
        foregroundColor: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: btn,
          foregroundColor: Colors.white,
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}