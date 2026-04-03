import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  static const Color textDark = Color(0xFF111111);
  static const Color borderColor = Color(0xFFE2DEE8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}