import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  static const String _googleLogoAsset = 'assets/fonts/image/google_logo.png';

  final String label;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  bool get isGoogle => label.toLowerCase() == 'google';

  Widget _buildGoogleBadge(Color color) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Image.asset(
        _googleLogoAsset,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.6),
            ),
            alignment: Alignment.center,
            child: Text(
              'G',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1,
              ),
            ),
          );
        },
      ),
    );
  }

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
            color: colorScheme.onSurface.withValues(alpha: 0.30),
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
              _buildGoogleBadge(colorScheme.onSurface),
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