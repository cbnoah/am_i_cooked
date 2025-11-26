import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class ProfilPictureContainer extends StatelessWidget {
  const ProfilPictureContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return M3Container.sunny(
      height: 200,
      width: 200,
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: const Color.,
            borderRadius: BorderRadius.circular(75),
          ),
        ),
      ),
    );
  }
}