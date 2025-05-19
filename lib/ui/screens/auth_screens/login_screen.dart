import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/password_visibility_provider.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/reusable_screen_layouts/authscreen_layout.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(
      authStateProvider.select((authState) => authState.generalError),
      (prev, next) {
        if (next != null) {
          WidgetsBinding.instance.addPostFrameCallback((_){
                ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
          });
        }
      },
    );

    ref.listen(
      authStateProvider.select((authState) => authState.user),
      (prev, next) async {
        if (next != null) {
          await ref
              .read(initialLocationProvider.notifier)
              .setInitialLocation('/home');
          if (context.mounted) context.go('/home');
        }
      },
    );

    final controllers = ref.watch(loginFormProvider);

    return AuthScreenLayout(
      emailController: controllers.emailController,
      passwordController: controllers.passwordController,
      title: 'Ready to get productive? Login',
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
      belowPassword: TextButton(
        onPressed: () {
          context.go('/password-reset');
        },
        child: Text(
          'Forgot Password?',
          style: Styles.textButtonStyle(fontSize: 13),
        ),
      ),
      buttonWidget: ref.watch(
              authStateProvider.select((authState) => authState.isLoading))
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Login',
              style: Styles.elevatedButtonTextStyle(),
            ),
      onSubmit: () async {
        await ref.read(authStateProvider.notifier).login(
              controllers.emailController.text.trim(),
              controllers.passwordController.text.trim(),
            );
      },
      bottomText: 'Don\'t have an account?',
      toggleText: 'Sign Up',
      onToggle: () {
        context.go('/signup');
      },
    );
  }
}
