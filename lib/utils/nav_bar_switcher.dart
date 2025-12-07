import 'package:flutter/material.dart';
import '../components/expanded_bottom_nav_bar_menu.dart';
import '../components/collapsed_bottom_nav_bar_menu.dart';

class BottomNavBarSwitcher extends StatelessWidget {
  static final ValueNotifier<bool> isExpanded = ValueNotifier(false);

  const BottomNavBarSwitcher({super.key});

  static void toggle() {
    isExpanded.value = !isExpanded.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, expanded, _) {
        return expanded
            ? const ExpandedBottomNavBarMenu()
            : const CollapsedBottomNavBarMenu();
      },
    );
  }
}
