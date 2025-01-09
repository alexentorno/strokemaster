import 'package:flutter/material.dart';
import 'package:stroke_master/base/screens/login/helper/validator.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  const NameInputField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Full Name *",
        labelStyle: AppStyles.mediumTextStyle.copyWith(fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: Validator.validateName,
    );
  }
}
