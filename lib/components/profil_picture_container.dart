import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class ProfilPictureContainer extends StatelessWidget {
  const ProfilPictureContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return M3Container.sunny(
      height: 200,
      width: 200,
      color: Colors.black,
      child: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 91, 41, 37),
            borderRadius: BorderRadius.circular(75),
          ),
        ),
      ),
    );
  }
}