import 'package:am_i_cooked/components/button_group.dart';
import 'package:am_i_cooked/utils/nav_bar_switcher.dart';
import 'package:flutter/material.dart';

class ExpandedBottomNavBarMenu extends StatelessWidget {
  const ExpandedBottomNavBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.tonal(
            onPressed: () => BottomNavBarSwitcher.toggle(),
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          ButtonGroup(),
        ],
      ),
    );
  }
}
