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
          title: Text(widget.hintText),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items
                  .map(
                    (item) => CheckboxListTile(
                      title: Text(
                        item.toString(),
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
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
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }
}

