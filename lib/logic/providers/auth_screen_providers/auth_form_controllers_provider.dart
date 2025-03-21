import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthFormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Disposes both the controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final authControllerProvider = Provider.autoDispose((ref) {
  final authController = AuthFormControllers();

  ref.onDispose(() {
    authController.dispose();
  });

  return authController;
});
