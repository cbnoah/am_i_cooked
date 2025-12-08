import 'package:flutter/material.dart';

import '../utils/page_route_builder.dart';

class ButtonGroup extends StatefulWidget {
  const ButtonGroup({super.key});

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 3,
      children: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(const Placeholder()));
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, buttonHeight),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            backgroundColor: Color(0xFFe8def8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.add_circle_outline, color: Color(0xFF4a4459)),
              Text(
                "Nouveau",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF4a4459),
                ),
              ),
            ],
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(const Placeholder()));
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, buttonHeight),
            backgroundColor: const Color(0xFFe8def8),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.bookmark, color: Color(0xFF4a4459)),
              Text(
                "Favoris",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF4a4459),
                ),
              ),
            ],
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(const Placeholder()));
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, buttonHeight),
            backgroundColor: const Color(0xFFe8def8),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.account_circle_outlined, color: Color(0xFF4a4459)),
              Text(
                "Profile",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF4a4459),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
