import 'package:am_i_cooked/pages/register_page_test.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPageTest extends StatefulWidget {
  const LoginPageTest({super.key});

  @override
  State<LoginPageTest> createState() => _LoginPageTestState();
}

class _LoginPageTestState extends State<LoginPageTest> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();
  late final AuthService _authService = AuthService(_dio);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.0,
          children: [
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
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => {
                if (_emailController.text != "" &&
                    _passwordController.text != "")
                  {
                    _authService.login(
                      _emailController.text,
                      _passwordController.text,
                    ),
                  }
                else
                  {print("missing attribute")},
              },
              child: Text("Login"),
            ),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPageTest(),
                ),
              ),
              child: Text("Register Page"),
            ),
          ],
        ),
      ),
    );
  }
}
