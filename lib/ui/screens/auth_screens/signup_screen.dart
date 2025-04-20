import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/password_strength_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/password_visibility_provider.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/reusable_screen_layouts/authscreen_layout.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authStateProvider.select((state) => state.generalError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        }
      },
    );

    ref.listen(
      authStateProvider.select((state) => state.user),
      (prev, next) async {
        if (next != null) {
          await ref
              .read(initialLocationProvider.notifier)
              .setInitialLocation('/home');
          if (context.mounted) context.go('/home');
        }
      },
    );

    final controllers = ref.watch(authControllerProvider);

    return AuthScreenLayout(
      emailController: controllers.emailController,
      passwordController: controllers.passwordController,
      title: 'Begin your notes taking adventure with us! Sign Up',
      emailError: ref
          .watch(authStateProvider.select((authState) => authState.emailError)),
      passwordError: ref.watch(
          authStateProvider.select((authState) => authState.passwordError)),
      clearErrorFunction: ref.read(authStateProvider.notifier).clearState,
      isPasswordHidden: ref.watch(passwordVisibilityProvider),
      visibilityOnPressed: () {
        ref.read(passwordVisibilityProvider.notifier).state =
            !ref.read(passwordVisibilityProvider);
      },
      strengthEvaluateFunction: (password) {
        ref.read(passwordStrengthProvider.notifier).evaluate(password);
      },
      belowPassword: ref.watch(authStateProvider
                      .select((authState) => authState.passwordError)) ==
                  null &&
              ref.watch(passwordStrengthProvider) != null
          ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Strength : ',
                    style: Styles.universalFont(color: colorScheme.onSurface),
                  ),
                  TextSpan(
                    text: ref.read(passwordStrengthProvider)!.passwordStrength,
                    style: Styles.universalFont(
                      color: ref
                          .read(passwordStrengthProvider)!
                          .passwordStrengthColor,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      buttonWidget:
          ref.watch(authStateProvider.select((state) => state.isLoading))
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Sign Up',
                  style: Styles.elevatedButtonTextStyle(),
                ),
      onSubmit: () {
        ref.read(authStateProvider.notifier).signup(
              controllers.emailController.text.trim(),
              controllers.passwordController.text.trim(),
            );
      },
      bottomText: 'Already have an account?',
      toggleText: 'Login',
      onToggle: () {
        ref.read(authStateProvider.notifier).clearState();
        context.go('/login');
      },
    );
  }
}
