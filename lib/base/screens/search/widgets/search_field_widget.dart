import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSearchChanged;

  SearchField({super.key, required this.onSearchChanged, required this.controller });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search videos...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        onChanged: (_) => onSearchChanged(),
      ),
    );
  }
}
