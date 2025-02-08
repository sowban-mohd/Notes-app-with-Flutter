import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Controllers {
  final LoginControllers loginControllers;
  final SignUpControllers signUpControllers;

  Controllers({
    required this.loginControllers,
    required this.signUpControllers,
  });
}

class LoginControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginControllers(
      {required this.emailController, required this.passwordController});

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class SignUpControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpControllers(
      {required this.emailController, required this.passwordController});

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final controllersProvider = Provider.autoDispose((ref) {
  final loginControllers = LoginControllers(
      emailController: TextEditingController(),
      passwordController: TextEditingController());
  final signupControllers = SignUpControllers(
      emailController: TextEditingController(),
      passwordController: TextEditingController());

  ref.onDispose(() {
    loginControllers.dispose();
    signupControllers.dispose();
  });

  return Controllers(
    loginControllers: loginControllers,
    signUpControllers: signupControllers,
  );
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);
