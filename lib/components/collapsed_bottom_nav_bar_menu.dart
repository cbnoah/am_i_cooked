import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/nav_bar_switcher.dart';

class CollapsedBottomNavBarMenu extends StatefulWidget {
  const CollapsedBottomNavBarMenu({super.key});

  @override
  State<CollapsedBottomNavBarMenu> createState() =>
      _CollapsedBottomNavBarMenuState();
}

class _CollapsedBottomNavBarMenuState extends State<CollapsedBottomNavBarMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        key: const ValueKey('searchRow'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => context.push('/search'),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: () => BottomNavBarSwitcher.toggle(),
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
