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
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              Text(
                "Nouveau",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              Text(
                "Favoris",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
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
          child: Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
