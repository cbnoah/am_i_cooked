import 'package:flutter/material.dart';
import '../components/login_text_field.dart';
import '../components/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  static const Color bgColor = Color(0xFFF3F2F7);
  static const Color cardColor = Colors.white;
  static const Color primaryColor = Color(0xFF6F46D9);
  static const Color textDark = Color(0xFF111111);
  static const Color textMuted = Color(0xFF6F6A78);
  static const Color dividerColor = Color(0xFFE2DEE8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                const SizedBox(height: 16),

                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E6EA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 56,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Am I Cooked ?',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Votre assistant culinaire intelligent',
                  style: const TextStyle(
                    fontSize: 14,
                    color: textMuted,
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
                    color: cardColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('EMAIL OR USERNAME'),
                      const SizedBox(height: 14),

                      const LoginTextField(
                        hint: 'chef@exemple.com',
                        prefixIcon: Icons.alternate_email_rounded,
                      ),

                      const SizedBox(height: 28),

                      _label('PASSWORD'),
                      const SizedBox(height: 14),

                      LoginTextField(
                        hint: '••••••••',
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
                            color: const Color(0xFF8A8592),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: const TextStyle(
                              color: primaryColor,
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            'Se connecter',
                            style: const TextStyle(
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
                          const Expanded(child: Divider(color: dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OU SE CONNECTER AVEC',
                              style: const TextStyle(
                                fontSize: 12,
                                color: textMuted,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: dividerColor)),
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
                          label: "Apple",
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
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "S'inscrire",
                        style: const TextStyle(
                          color: primaryColor,
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textDark,
        letterSpacing: 1.0,
      ),
    );
  }
}