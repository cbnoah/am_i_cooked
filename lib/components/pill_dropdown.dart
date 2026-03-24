import 'package:flutter/material.dart';

class PillDropdown<T> extends StatelessWidget {
  const PillDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onSelected,
    required this.hintStyle,
  });

  final String hintText;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onSelected;
  final TextStyle hintStyle;

  @override
  Widget build(BuildContext context) {
    const pill = Color(0xFF6750A4);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: pill,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          // hide default icon and render our own so we can center the text
          icon: const SizedBox.shrink(),

          // When nothing selected: show centered hint with arrow on the right
          hint: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    hintText,
                    style: hintStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),

          // When something is selected: build a widget that centers the text
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        e.toString(),
                        style: hintStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              );
            }).toList();
          },

          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),

          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          onChanged: onSelected,
        ),
      ),
    );
  }
}
