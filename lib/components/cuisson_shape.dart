import 'dart:math' as math;
import 'package:flutter/material.dart';


class Stars extends StatelessWidget {
  const Stars({super.key});

  get M3Container => null;

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
                'assets/images/your_image.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
