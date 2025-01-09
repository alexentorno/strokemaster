import 'package:flutter/material.dart';
import 'package:stroke_master/base/screens/login/helper/validator.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Email *",
        labelStyle: AppStyles.mediumTextStyle.copyWith(fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: Validator.validateEmail,
    );
  }
}
