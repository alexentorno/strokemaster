import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';

import 'widgets/email_field_widget.dart';
import 'widgets/login_button_widget.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/password_field_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final authProvider = ref.read(authenticationProvider.notifier);
    await authProvider.loginWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = ref.watch(authenticationProvider);

    // Listen for login status
    ref.listen(isLoggedInProvider, (_, isLoggedIn) {
      if (isLoggedIn && Navigator.of(context).canPop()) {
        context.pop();
      }
    });

    // Listen for authentication errors
    ref.listen(authenticationProvider, (AuthState? previous, AuthState current) {
      if (current.result == AuthResult.failure && !current.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wrong email or password!",
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
                LoginHeader(theme: theme),
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
                LoginButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authProvider.isLoading ? null : _attemptLogin();
                    }
                  },
                  isLoading: authProvider.isLoading,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
