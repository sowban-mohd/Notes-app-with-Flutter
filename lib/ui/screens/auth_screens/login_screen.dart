import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import '../../../providers/initial_location_provider.dart';
import '../../widgets/authscreen_layout.dart';
import '../../../providers/auth_screen_providers/auth_state_provider.dart';
import '../../../providers/controllers_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(authControllerProvider);

    //Gets access to authentication state and notifier
    final loginState = ref.watch(authStateProvider);
    final loginNotifier = ref.read(authStateProvider.notifier);

    //Gets access to bool value which indicates if the password is hidden
    final isPasswordHidden = ref.watch(passwordVisibilityProvider);

    if (loginState.generalError != null || loginState.successMessage != null) {
      showSnackbarMessage(context,
          message: loginState.generalError ?? loginState.successMessage!);
    }

    //Navigates to notes screen if login is successful
    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage == 'Login is successful') {
        //Gets access to initial location notifier
        final initialLocationNotifier =
            ref.read(initialLocationProvider.notifier);
        initialLocationNotifier.setInitialLocation('/home'); //Sets note screen as the initial screen of app
        loginNotifier.clearState();
        context.go('/home');
      }
    });

    return AuthScreenLayout(
        emailController: controllers.emailController,
        passwordController: controllers.passwordController,
        title: 'Ready to get productive? Login',
        emailError: loginState.emailError,
        passwordError: loginState.passwordError,
        clearErrorFunction: loginNotifier.clearState,
        isPasswordHidden: isPasswordHidden,
        visibilityOnPressed: () {
          ref.read(passwordVisibilityProvider.notifier).state =
              !isPasswordHidden;
        },
        belowPassword: TextButton(
          onPressed: () {
            loginNotifier.clearState();
            context.go('/password-reset');
          },
          child: Text(
            'Forgot Password?',
            style: Styles.textButtonStyle(fontSize: 13),
          ),
        ),
        buttonWidget: loginState.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: Styles.elevatedButtonTextStyle(),
              ),
        onSubmit: () {
          loginNotifier.authenticate(controllers.emailController.text.trim(),
              controllers.passwordController.text.trim());
        },
        bottomText: 'Don\'t have an account?',
        toggleText: 'Sign Up',
        onToggle: () {
          loginNotifier.clearState();
          context.go('/signup');
        });
  }
}
