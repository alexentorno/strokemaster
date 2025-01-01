import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';

import 'helper/validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    ref.listen(isLoggedInProvider, (_, isLoggedIn) {
      if (isLoggedIn && Navigator.of(context).canPop()) {
        context.pop();
      }
    });

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
      appBar: AppBar(
        title: const ShowLogo(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColor),
                ),
                Row(
                  children: [
                    Text("Don't have an account?",
                        style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight)),
                    TextButton(
                      onPressed: () => context.push("/register"),
                      child: Text(
                        "Register",
                        style: AppStyles.mediumTextStyle.copyWith(
                          color: theme.highlightColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email *",
                    labelStyle: AppStyles.mediumTextStyle.copyWith(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: Validator.validateEmail,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password *",
                    labelStyle: AppStyles.mediumTextStyle.copyWith(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: Validator.validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: theme.primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authProvider.isLoading ? null : _attemptLogin();
                    }
                  },
                  child: Text("Login",
                      style: AppStyles.mediumTextStyle.copyWith(
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
