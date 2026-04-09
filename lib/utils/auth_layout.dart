import 'package:am_i_cooked/pages/login_page.dart';
import 'package:am_i_cooked/pages/login_page_test.dart';
import 'package:am_i_cooked/pages/main_page.dart';
import 'package:am_i_cooked/service/token_service.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    TokenService tokenInstance = TokenService.instance;
    return StreamBuilder(
      stream: tokenInstance.accessTokenStream,
      builder: (context, snapshot) {
        // loading response
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = snapshot.data;

        if (session != null && session.isNotEmpty) {
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
