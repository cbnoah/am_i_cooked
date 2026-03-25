import 'package:flutter/material.dart';

class MultiSelectPillDropdown<T> extends StatefulWidget {
  const MultiSelectPillDropdown({
    super.key,
    required this.hintText,
    required this.values,
    required this.items,
    required this.onSelected,
    required this.hintStyle,
  });

  final String hintText;
  final List<T> values;
  final List<T> items;
  final ValueChanged<List<T>> onSelected;
  final TextStyle hintStyle;

  @override
  State<MultiSelectPillDropdown<T>> createState() =>
      _MultiSelectPillDropdownState<T>();
}

class _MultiSelectPillDropdownState<T> extends State<MultiSelectPillDropdown<T>> {
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.values);
  }

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
      child: GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  selectedItems.isEmpty
                      ? widget.hintText
                      : '${selectedItems.length} sélectionné(s)',
                  style: widget.hintStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFFF3F1FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          title: Text(
            widget.hintText,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6750A4),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items
                  .asMap()
                  .entries
                  .map(
                    (entry) {
                      final item = entry.value;
                      return CheckboxListTile(
                        activeColor: const Color(0xFF6750A4),
                        checkColor: Colors.white,
                        title: Text(
                          item.toString(),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: selectedItems.contains(item),
                        onChanged: (isChecked) {
                          setStateDialog(() {
                            if (isChecked == true) {
                              selectedItems.add(item);
                            } else {
                              selectedItems.remove(item);
                            }
                          });
                          widget.onSelected(List.from(selectedItems));
                        },
                      );
                    },
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Fermer',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

