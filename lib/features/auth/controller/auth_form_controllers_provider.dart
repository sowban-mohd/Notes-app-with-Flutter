import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthFormControllers {
  final LoginFormControllers loginFormControllers;
  final SignupFormControllers signUpFormControllers;
  final TextEditingController passwordResetController;

  AuthFormControllers(
      {required this.loginFormControllers,
      required this.signUpFormControllers,
      required this.passwordResetController});
}

class LoginFormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class SignupFormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final authFormControllers = Provider.autoDispose((ref) {
  final loginFormControllers = LoginFormControllers();
  final signUpFormControllers = SignupFormControllers();
  final passwordResetController = TextEditingController();

  ref.onDispose(() {
    loginFormControllers.dispose();
    signUpFormControllers.dispose();
    passwordResetController.dispose();
  });

  return AuthFormControllers(
      loginFormControllers: loginFormControllers,
      signUpFormControllers: signUpFormControllers,
      passwordResetController: passwordResetController);
});
