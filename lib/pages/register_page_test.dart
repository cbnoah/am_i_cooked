import 'package:am_i_cooked/pages/login_page_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class RegisterPageTest extends StatefulWidget {
  const RegisterPageTest({super.key});

  @override
  State<RegisterPageTest> createState() => _RegisterPageTestState();
}

class _RegisterPageTestState extends State<RegisterPageTest> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Dio _dio = Dio();
  late final AuthService _authService = AuthService(_dio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.0,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => {
                if (_emailController.text != "" &&
                    _usernameController.text != "" &&
                    _passwordController.text != "" &&
                    _passwordController.text == _confirmPasswordController.text)
                  {
                    _authService.register(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    ),
                  },
              },
              child: Text("Register"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Login Page"),
            ),
          ],
        ),
      ),
    );
  }
}
