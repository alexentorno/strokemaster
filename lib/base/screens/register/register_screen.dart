import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/screens/login/widgets/email_field_widget.dart';
import 'package:stroke_master/base/screens/login/widgets/password_field_widget.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';

import 'widgets/header_section_widget.dart';
import 'widgets/name_field_widget.dart';
import 'widgets/register_button_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = ref.read(authenticationProvider.notifier);
      await authProvider.registerWithEmailAndPassword(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(isLoggedInProvider, (_, isLoggedIn) {
      if (isLoggedIn) context.pop();
    });

    ref.listen(authenticationProvider, (AuthState? previous, AuthState current) {
      if (current.result == AuthResult.userAlreadyExists && !current.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "User already exists!",
              style: AppStyles.mediumTextStyle,
            ),
            backgroundColor: Colors.deepPurpleAccent,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const ShowLogo()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                const SizedBox(height: 10),
                NameInputField(controller: _nameController),
                const SizedBox(height: 15),
                EmailField(controller: _emailController),
                const SizedBox(height: 15),
                PasswordField(
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                RegisterButton(
                  isLoading: ref.watch(authenticationProvider).isLoading,
                  onPressed: _attemptRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

