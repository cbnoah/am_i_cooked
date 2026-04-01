import 'package:flutter/material.dart';

class LoginPageTest extends StatefulWidget {
  const LoginPageTest({super.key});

  @override
  State<LoginPageTest> createState() => _LoginPageTestState();
}

class _LoginPageTestState extends State<LoginPageTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Login Page Test"),
      ),
    );
  }
}
