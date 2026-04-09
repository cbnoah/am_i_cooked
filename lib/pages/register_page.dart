import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/login_text_field.dart';
import '../components/profil_picture_container.dart';
import '../components/social_login_button.dart';
import '../service/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscurePassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Dio _dio = Dio();
  late final AuthService _authService = AuthService(_dio);

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
                  'Créez votre compte culinaire',
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
                      _label(context, 'NOM D\'UTILISATEUR'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: 'jean_dupont',
                        controller: _usernameController,
                        prefixIcon: Icons.alternate_email_rounded,
                      ),

                      const SizedBox(height: 24),

                      _label(context, 'EMAIL'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: 'chef@exemple.com',
                        controller: _emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                      ),

                      const SizedBox(height: 24),

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
                      const SizedBox(height: 24),

                      _label(context, 'CONFIRMEZ VOTRE MOT DE PASSE'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: '••••••••',
                        controller: _confirmPasswordController,
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

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_emailController.text != "" &&
                                _usernameController.text != "" &&
                                _passwordController.text != "" &&
                                _passwordController.text ==
                                    _confirmPasswordController.text) {
                              final bool result = await _authService.register(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (result && context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              print("missing arguments");
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
                            "S'inscrire",
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
                              'OU S’INSCRIRE AVEC',
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
                      'Déjà un compte ? ',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: cs.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Se connecter',
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
