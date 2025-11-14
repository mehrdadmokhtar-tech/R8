import 'package:flutter/material.dart';

class DynamicBoxes extends StatefulWidget {
  final List<String> items;
  final Function(int)? onSelected;

  const DynamicBoxes({super.key, required this.items, this.onSelected});

  @override
  State<DynamicBoxes> createState() => _DynamicBoxesState();
}

class _DynamicBoxesState extends State<DynamicBoxes> {
  int? selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: List.generate(widget.items.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onSelected?.call(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary,
              ),
            ),
            child: Text(
              widget.items[index],
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
  }
}
