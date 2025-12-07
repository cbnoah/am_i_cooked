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
              backgroundColor: const Color(0xFFece6f0),
            ),
            child: const Icon(Icons.add, color: Color(0xFF1d1b20)),
          ),
          ButtonGroup(),
        ],
      ),
    );
  }
}
