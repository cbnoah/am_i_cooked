import 'package:flutter/material.dart';

class RegisterPageTest extends StatefulWidget {
  const RegisterPageTest({super.key});

  @override
  State<RegisterPageTest> createState() => _RegisterPageTestState();
}

class _RegisterPageTestState extends State<RegisterPageTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Register Page Test"),
      ),
    );
  }
}
