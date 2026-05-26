import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class ProfilePictureContainer extends StatelessWidget {
  static const String _pathPlaceHolderImage =
      "assets/image/logo.png";
  final String? pathImage;
  final Uint8List? imageBlob;
  final bool isEditIconVisible;
  final VoidCallback? onEditPressed;

  const ProfilePictureContainer({
    super.key,
    required this.isEditIconVisible,
    required this.onEditPressed,
    this.imageBlob,
    this.pathImage,
  });

  ImageProvider<Object> _resolveImageProvider() {
    if (imageBlob != null && imageBlob!.isNotEmpty) {
      return MemoryImage(imageBlob!);
    }
    return const AssetImage(_pathPlaceHolderImage);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _resolveImageProvider();
    return M3Container.sunny(
      height: 200,
      width: 200,
      color: const Color(0xFF4F378A),
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF4F378A),
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
