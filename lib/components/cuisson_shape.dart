import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes/flutter_m3shapes.dart';


class Stars extends StatelessWidget {
  const Stars({super.key});

  @override
  Widget build(BuildContext context) {
    return M3Container.verySunny(
      color: Color(0xFF6750A4),
      height: 200,
      width: 200,
      child: Transform.rotate(
        angle: math.pi / 8,
        child: M3Container.verySunny(
          color: Color(0xFFEADDFF),
          height: 155,
          width: 155,
          child: Transform.rotate(
            angle: math.pi / -8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/5stars.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
