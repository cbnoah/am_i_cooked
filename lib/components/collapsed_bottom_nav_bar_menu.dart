import 'package:flutter/material.dart';

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
          SizedBox(
            width: MediaQuery.of(context).size.width - 90,
            child: Hero(
              tag: "searchBar",
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/search');
                },
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF49454f),
                    ),
                    hintText: "Search",
                    hintStyle: const TextStyle(
                      fontFamily: "nunito",
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF49454f),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ),
          ),
          Hero(
            tag: "openMenuButton",
            child: FilledButton.tonal(
              onPressed: () => BottomNavBarSwitcher.toggle(),
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFFeaddff),
              ),
              child: const Icon(Icons.add, color: Color(0xFF1d1b20)),
            ),
          ),
        ],
      ),
    );
  }
}
