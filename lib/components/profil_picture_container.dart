import 'dart:io';
import 'package:am_i_cooked/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class ProfilePictureContainer extends StatelessWidget {
  final String pathImage;
  final bool isEditIconVisible;
  final VoidCallback? onEditPressed;

  const ProfilePictureContainer({
    super.key,
    required this.pathImage,
    required this.isEditIconVisible,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return M3Container.sunny(
      height: 200,
      width: 200,
      color: Color(0xFF4F378A),
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: pathImage.startsWith("http")
                ? NetworkImage(pathImage) as ImageProvider  
                : FileImage(File(pathImage)),
                fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(75),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          alignment: Alignment.bottomRight,
          child: isEditIconVisible
              ? FloatingActionButton(
                  onPressed: onEditPressed,
                  shape: CircleBorder(),
                  backgroundColor: Color(0xFF4F378A),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.surface,
                    size: 25,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
