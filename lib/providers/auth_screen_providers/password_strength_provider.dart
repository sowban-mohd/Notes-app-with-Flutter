import 'package:password_strength/password_strength.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages password strength indicator
class PasswordStrength {
  final String? passwordStrength;
  final Color? passwordStrengthColor;

  PasswordStrength({this.passwordStrength, this.passwordStrengthColor});
}

/// Notifier which manages, exposes password strength indicator
class PasswordStrengthNotifier extends Notifier<PasswordStrength> {
  @override
  PasswordStrength build() => PasswordStrength();

  /// Evaluates password strength
  void evaluate(String password) {
    //Ensures strength message isn't displayed when password field is emptied
    if (password.isEmpty) {
      state = PasswordStrength();
      return;
    }

    double strength = estimatePasswordStrength(password);
    String passwordStrength;
    Color passwordStrengthColor;

    /// Sets message and message color based on password strength
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

/// Provider of PasswordStrengthNotifier
final passwordStrengthProvider =
    NotifierProvider<PasswordStrengthNotifier, PasswordStrength>(
        PasswordStrengthNotifier.new);
