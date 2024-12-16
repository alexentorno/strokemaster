import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class CustomFilterChips extends StatelessWidget {
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;
  final String label;

  const CustomFilterChips({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight)
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            final isSelected = selectedItems.contains(option);
            return FilterChip(
              side: BorderSide.none,
              label: Text(
                option,
                style: AppStyles.mediumTextStyle.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
              selected: isSelected,
              backgroundColor: Colors.grey[200],
              selectedColor: label == "Where?" ? Colors.blue : Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (isSelected) {
                final updatedSelection = List<String>.from(selectedItems);
                if (isSelected) {
                  updatedSelection.add(option);
                } else {
                  updatedSelection.remove(option);
                }
                onSelectionChanged(updatedSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
