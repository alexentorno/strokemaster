import 'package:flutter/material.dart';
import 'package:stroke_master/base/screens/search/widgets/custom_filter_chips_widget.dart';

class FiltersSection extends StatelessWidget {
  final List<String> selectedWhere;
  final List<String> selectedDifficulty;
  final Function(List<String>) onWhereSelectionChanged;
  final Function(List<String>) onDifficultySelectionChanged;

  final List<String> whereOptions = ["On Water", "Gym", "Warm up"];
  final List<String> difficultyOptions = ["Beginner", "Advanced", "Professional"];

  FiltersSection({
    super.key,
    required this.selectedWhere,
    required this.selectedDifficulty,
    required this.onWhereSelectionChanged,
    required this.onDifficultySelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1, // Stick the filters to the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomFilterChips(
                  label: "Where?",
                  options: whereOptions,
                  selectedItems: selectedWhere,
                  onSelectionChanged: onWhereSelectionChanged,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomFilterChips(
                  label: "Difficulty level",
                  options: difficultyOptions,
                  selectedItems: selectedDifficulty,
                  onSelectionChanged: onDifficultySelectionChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
