import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:am_i_cooked/theme/dark_theme_data.dart';
import 'package:am_i_cooked/theme/light_theme_data.dart';
import 'package:am_i_cooked/utils/auth_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  final authService = AuthService(dio);
  await authService.bootstrapSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: lightTheme,
      dark: darkTheme,
      builder: (light, dark) => MaterialApp(
        title: 'Am I Cooked?',
        theme: light,
        darkTheme: dark,
        home: AuthLayout(),
      ),
    );
  }
}
