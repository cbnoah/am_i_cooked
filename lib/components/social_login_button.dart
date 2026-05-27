import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  bool get isGoogle => label.toLowerCase() == 'google';
  bool get isApple => label.toLowerCase() == 'apple';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 60,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          side: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.22),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle) ...[
              Image.asset(
                'assets/image/google_logo.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                color: colorScheme.onSurface,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.g_mobiledata_rounded,
                    size: 24,
                    color: colorScheme.onSurface,
                  );
                },
              ),
              const SizedBox(width: 10),
            ],

            if (isApple) ...[
              Image.asset(
                'assets/image/apple.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: colorScheme.onSurface,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.apple,
                    size: 22,
                    color: colorScheme.onSurface,
                  );
                },
              ),
              const SizedBox(width: 10),
            ],

            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}