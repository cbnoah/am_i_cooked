import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:am_i_cooked/pages/main_page.dart';
import 'package:am_i_cooked/theme/dark_theme_data.dart';
import 'package:am_i_cooked/theme/light_theme_data.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:am_i_cooked/components/xp_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: lightTheme,
      dark: darkTheme,
      builder: (light, dark) => MaterialApp(
        title: 'Am I Cooked?',
        theme: light,
        darkTheme: dark,
        home: MainPage(),
      ),
    );
  }
}
