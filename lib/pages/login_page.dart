import 'package:am_i_cooked/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../components/login_text_field.dart';
import '../components/social_login_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHigh,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                const SizedBox(height: 16),

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    'assets/fonts/image/logo.png',
                    fit: BoxFit.fill,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Am I Cooked ?',
                  style: TextStyle(
                    fontFamily: 'bbh_sans_hegarty',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Votre assistant culinaire intelligent',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 34),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(context, 'EMAIL'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: 'chef@exemple.com',
                        prefixIcon: Icons.alternate_email_rounded,
                        controller: _emailController,
                      ),

                      const SizedBox(height: 28),

                      _label(context, 'MOT DE PASSE'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: '••••••••',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_rounded,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Mot de passe oubliée?',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_emailController.text != "" &&
                                _passwordController.text != "") {
                              _authService.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Veuillez entrer tout les éléments",
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(child: Divider(color: cs.outline)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OU SE CONNECTER AVEC',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: cs.outline)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Google',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Apple',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas de compte ? ',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: cs.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
        letterSpacing: 1.0,
      ),
    );
  }
}
