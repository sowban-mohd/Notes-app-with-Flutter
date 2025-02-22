import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  AuthController({
    required this.emailController,
    required this.passwordController,
  });

  /// Disposes both the controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final authControllerProvider = Provider.autoDispose((ref) {
  final authController = AuthController(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
  );

  ref.onDispose(() {
    authController.dispose();
  });

  return authController;
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);
