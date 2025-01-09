import 'package:flutter/material.dart';
import 'package:stroke_master/base/screens/login/helper/validator.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;

  const PasswordField({super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password *",
        labelStyle: AppStyles.mediumTextStyle.copyWith(fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityToggle,
        ),
      ),
      validator: Validator.validatePassword,
    );
  }
}
