import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import '../../widgets/authscreen_layout.dart';
import '../../../providers/controllers_provider.dart';
import '../../../providers/auth_screen_providers/password_strength_provider.dart';
import '../../../providers/auth_screen_providers/auth_state_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(authControllerProvider);

    //Gets access to authentication state and notifier
    final signUpState = ref.watch(authStateProvider);
    final signUpStateNotifier = ref.read(authStateProvider.notifier);

    //Gets access to password strength message state and notifier
    final passwordStrengthState = ref.watch(passwordStrengthProvider);
    final passwordStrengthNotifier =
        ref.read(passwordStrengthProvider.notifier);

    //Gets access to bool value which indicates if the password is hidden
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

    // Navigate to login screen on successful signup
    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage != null) {
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
                    style: Styles.universalFont(color: colorScheme.onSurface),
                  ),
                  TextSpan(
                    text: passwordStrengthState.passwordStrength!,
                    style: Styles.universalFont(
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
                color: colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Sign Up',
              style: Styles.elevatedButtonTextStyle(),
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
