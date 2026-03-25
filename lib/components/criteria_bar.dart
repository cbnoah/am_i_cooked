
import 'package:flutter/material.dart';

class RecipeCriteriaBar extends StatelessWidget {
  final List<String> criteria;
  final double height;
  final EdgeInsetsGeometry padding;

  const RecipeCriteriaBar({
    super.key,
    required this.criteria,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: criteria.map((c) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(
                    c,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
