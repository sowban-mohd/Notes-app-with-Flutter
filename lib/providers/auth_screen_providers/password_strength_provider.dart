import 'package:password_strength/password_strength.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordStrength {
  final String? passwordStrength;
  final Color? passwordStrengthColor;

  PasswordStrength({this.passwordStrength, this.passwordStrengthColor});
}

// Notifier for password strength
class PasswordStrengthNotifier extends Notifier<PasswordStrength> {

  @override
  PasswordStrength build() => PasswordStrength();

  void evaluate(String password) {
    if (password.isEmpty) {
      state = PasswordStrength();
      return;
    }

    double strength = estimatePasswordStrength(password);
    String passwordStrength;
    Color passwordStrengthColor;

    if (strength <= 0.2) {
      passwordStrength = 'weak';
      passwordStrengthColor = Colors.red;
    } else if (strength <= 0.6) {
      passwordStrength = 'medium';
      passwordStrengthColor = const Color.fromRGBO(230, 160, 0, 1);
    } else {
      passwordStrength = 'strong';
      passwordStrengthColor = Colors.green;
    }

    state = PasswordStrength(
        passwordStrength: passwordStrength,
        passwordStrengthColor: passwordStrengthColor);
  }
}

final passwordStrengthProvider =
    NotifierProvider<PasswordStrengthNotifier, PasswordStrength>(
        PasswordStrengthNotifier.new);
