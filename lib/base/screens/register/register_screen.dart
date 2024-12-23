import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/screens/login/helper/validator.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/models/auth_result.dart';
import 'package:stroke_master/state/auth/models/auth_state.dart';
import 'package:stroke_master/state/auth/providers/authentication_provider.dart';
import 'package:stroke_master/state/auth/providers/is_logged_in_provider.dart';

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


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      print('name: $name, email: $email, password: $password');

      final authProvider = ref.read(authenticationProvider.notifier);
      await authProvider.registerWithEmailAndPassword(
          email: email, name: name, password: password);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = ref.watch(authenticationProvider);

    // If the user has registered successfully, we pop the current view
    ref.listen(isLoggedInProvider, (_, isLoggedIn) => context.pop());

    ref.listen(authenticationProvider,
            (AuthState? previous, AuthState current) {
          // Check if the state is not loading and login failed
          if (current.result == AuthResult.userAlreadyExists && !current.isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("User already exists!",
                style: AppStyles.mediumTextStyle,),
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
                  "Register",
                  style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColor),
                ),
                Row(
                  children: [
                    Text("Already have an account?",
                        style: AppStyles.mediumTextStyle.copyWith(color: theme.primaryColorLight)),
                    TextButton(
                      onPressed: () => context.push("/login"),
                      child: Text(
                        "Login",
                        style: AppStyles.mediumTextStyle.copyWith(
                            color: theme.highlightColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: Validator.validateName,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: Validator.validateEmail,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                  validator: Validator.validatePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: authProvider.isLoading ? null : _attemptRegister,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
