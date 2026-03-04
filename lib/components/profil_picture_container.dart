import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color backgroundColor;

  const ProfilePicture({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 120,
    this.backgroundColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildInitials(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _buildInitials(),
                  )
                : _buildInitials(),
          ),
        ),
      ),
    );
  }

  Widget _buildInitials() {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          initials ?? '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}