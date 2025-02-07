import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetakingapp1/widgets/reusable_authscreen_layout.dart';
import '../providers/signup_screen_controllers.dart';
import '../providers/password_strength_provider.dart';
import '../providers/auth_state_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signupStateProvider);
    final signUpStateNotifier = ref.read(signupStateProvider.notifier);
    final passwordStrengthState = ref.watch(passwordStrengthProvider);
    final passwordStrengthNotifier =
        ref.read(passwordStrengthProvider.notifier);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
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

    ref.listen(signupStateProvider, (previous, next) {
      if (next.successMessage != null) {
        // Navigate to login screen on successful signup
        context.go('/LoginScreen');
      }
    });

    return AuthScreenLayout(
      emailController: emailController,
      passwordController: passwordController,
      title: 'Begin your notes taking adventure with us! Sign Up',
      emailError: signUpState.emailError,
      passwordError: signUpState.passwordError,
      clearErrorFunction: signUpStateNotifier.clearError,
      isPasswordHidden: isPasswordHidden,
      visibilityOnPressed: () {
        ref.read(passwordVisibilityProvider.notifier).state = !isPasswordHidden;
      },
      strengthEvaluateFunction: (password) {
        passwordStrengthNotifier.evaluate(password);
      },
      belowPassword: signUpState.passwordError == null
          ? passwordStrengthState.passwordStrength != null
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
              : const SizedBox.shrink()
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
            emailController.text.trim(), passwordController.text.trim(),
            isSignup: true);
      },
      bottomText: 'Already have an account?',
      toggleText: 'Login',
      onToggle: () {
        signUpStateNotifier.clearError();
        context.go('/LoginScreen');
      },
    );
  }
}
