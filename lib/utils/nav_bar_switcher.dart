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
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: isExpanded.value ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          child: expanded
              ? const ExpandedBottomNavBarMenu(key: ValueKey('expanded'))
              : const CollapsedBottomNavBarMenu(key: ValueKey('collapsed')),
        );
      },
    );
  }
}
