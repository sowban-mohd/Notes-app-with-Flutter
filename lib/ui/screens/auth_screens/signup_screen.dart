import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/authscreen_layout.dart';
import '../../../providers/controllers_provider.dart';
import '../../../providers/auth_screen_providers/password_strength_provider.dart';
import '../../../providers/auth_screen_providers/auth_state_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(authStateProvider);
    final signUpStateNotifier = ref.read(authStateProvider.notifier);
    final passwordStrengthState = ref.watch(passwordStrengthProvider);
    final passwordStrengthNotifier =
        ref.read(passwordStrengthProvider.notifier);
    final controllers = ref.watch(controllersProvider).signUpControllers;
    final isPasswordHidden = ref.watch(passwordVisibilityProvider);
    
    if (signUpState.generalError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(signUpState.generalError!),
          ),
        );
      });
    }

    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage != null) {
        // Navigate to login screen on successful signup
        context.go('/login');
      }
    });

    return AuthScreenLayout(
      emailController: controllers.emailController,
      passwordController: controllers.passwordController,
      title: 'Begin your notes taking adventure with us! Sign Up',
      emailError: signUpState.emailError,
      passwordError: signUpState.passwordError,
      clearErrorFunction: signUpStateNotifier.clearState,
      isPasswordHidden: isPasswordHidden,
      visibilityOnPressed: () {
        ref.read(passwordVisibilityProvider.notifier).state = !isPasswordHidden;
      },
      strengthEvaluateFunction: (password) {
        passwordStrengthNotifier.evaluate(password);
      },
      belowPassword: signUpState.passwordError == null &&
              passwordStrengthState.passwordStrength != null
          ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Strength : ',
                    style: GoogleFonts.nunitoSans(color: Colors.black),
                  ),
                  TextSpan(
                    text: passwordStrengthState.passwordStrength!,
                    style: GoogleFonts.nunito(
                        color: passwordStrengthState.passwordStrengthColor),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      buttonWidget: signUpState.isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Sign Up',
              style: GoogleFonts.nunitoSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
      onSubmit: () {
        signUpStateNotifier.authenticate(
            controllers.emailController.text.trim(),
            controllers.passwordController.text.trim(),
            isSignup: true);
      },
      bottomText: 'Already have an account?',
      toggleText: 'Login',
      onToggle: () {
        signUpStateNotifier.clearState();
        context.go('/login');
      },
    );
  }
}
