import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';

class ProfilPictureContainer extends StatelessWidget {
  const ProfilPictureContainer({super.key});

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
            image: const DecorationImage(
              image: AssetImage('assets/images/avatar_image.jpg'),
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
          child: FloatingActionButton(onPressed: () {},
          shape: CircleBorder(),
          backgroundColor: Color(0xFF4F378A),
          child: Icon(Icons.edit_outlined, color: Colors.white, size: 20,),
          ),
        ),
      ),
    );
  }
}