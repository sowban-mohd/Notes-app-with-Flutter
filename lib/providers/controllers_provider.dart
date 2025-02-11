import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Controllers {
  final LoginControllers loginControllers;
  final SignUpControllers signUpControllers;
  final ForgotPasswordController forgotPasswordController;
  final NotesController notesController;

  Controllers({
    required this.loginControllers,
    required this.signUpControllers,
    required this.forgotPasswordController,
    required this.notesController,
  });
}

class LoginControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginControllers({
    required this.emailController,
    required this.passwordController,
  });

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class SignUpControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpControllers({
    required this.emailController,
    required this.passwordController,
  });

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class ForgotPasswordController {
  final TextEditingController emailController;

  const ForgotPasswordController({required this.emailController});

  void dispose() {
    emailController.dispose();
  }
}

class NotesController {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const NotesController({
    required this.titleController,
    required this.contentController,
  });

  void dispose() {
    titleController.dispose();
    contentController.dispose();
  }
}

final controllersProvider = Provider.autoDispose((ref) {
  final loginControllers = LoginControllers(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
  );
  final signupControllers = SignUpControllers(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
  );
  final forgotPasswordController = ForgotPasswordController(
    emailController: TextEditingController(),
  );
  final notesController = NotesController(
    titleController: TextEditingController(),
    contentController: TextEditingController(),
  );

  ref.onDispose(() {
    loginControllers.dispose();
    signupControllers.dispose();
    forgotPasswordController.dispose();
    notesController.dispose();
  });

  return Controllers(
    loginControllers: loginControllers,
    signUpControllers: signupControllers,
    forgotPasswordController: forgotPasswordController,
    notesController: notesController,
  );
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);
