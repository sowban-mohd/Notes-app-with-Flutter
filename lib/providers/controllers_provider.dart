import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Controllers {
  final LoginControllers loginControllers;
  final SignUpControllers signUpControllers;
  final ForgotPasswordController forgotPasswordController;

  Controllers({
    required this.loginControllers,
    required this.signUpControllers,
    required this.forgotPasswordController,
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

class ForgotPasswordController {
  final TextEditingController emailController;

  const ForgotPasswordController({required this.emailController});

  void dispose(){
    emailController.dispose();
  }
}

final controllersProvider = Provider.autoDispose((ref) {
  final loginControllers = LoginControllers(
      emailController: TextEditingController(),
      passwordController: TextEditingController());
  final signupControllers = SignUpControllers(
      emailController: TextEditingController(),
      passwordController: TextEditingController());

  final forgotPasswordController = ForgotPasswordController(
      emailController: TextEditingController());

  ref.onDispose(() {
    loginControllers.dispose();
    signupControllers.dispose();
    forgotPasswordController.dispose();
  });

  return Controllers(
    loginControllers: loginControllers,
    signUpControllers: signupControllers,
    forgotPasswordController: forgotPasswordController,
  );
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);
