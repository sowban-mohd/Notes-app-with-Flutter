import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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


final loginFormProvider = Provider.autoDispose((ref) {
  final controllers = LoginFormControllers();
  ref.onDispose(controllers.dispose);
  return controllers;
});

final signupFormProvider = Provider.autoDispose((ref) {
  final controllers = SignupFormControllers();
  ref.onDispose(controllers.dispose);
  return controllers;
});

final passwordResetFormProvider = Provider.autoDispose((ref) {
  final passwordController = TextEditingController();
  ref.onDispose(passwordController.dispose);
  return passwordController;
});
