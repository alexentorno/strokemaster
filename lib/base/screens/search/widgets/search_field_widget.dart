import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ThemeData theme;

  const SearchField({super.key, required this.onChanged, required this.theme});

  @override
  Widget build(BuildContext context) {
    return TextField(
      showCursor: false,
      decoration: InputDecoration(
        hintText: "Type here",
        hintStyle: AppStyles.mediumTextStyle.copyWith(color: theme.hintColor, fontSize: 16), // Adjust hint text color dynamically
        prefixIcon: Icon(
          Icons.search,
          color: theme.primaryColorLight, // Adjust icon color
        ),
        // Border color when the text field is focused (selected)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.primaryColor), // Color when focused
        ),
        // Border color when the text field is not focused (unselected)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.disabledColor), // Color when not focused
        ),
      ),
      onChanged: onChanged,
    );
  }
}
