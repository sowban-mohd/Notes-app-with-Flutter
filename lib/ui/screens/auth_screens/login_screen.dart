import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

    //Gets access to initial location value and notifier
    final initialLocationNotifier = ref.read(initialLocationProvider.notifier);

    if (loginState.generalError != null || loginState.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(loginState.generalError ?? loginState.successMessage!),
          ),
        );
      });
    }

    //Navigates to notes screen if login is successful
    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage == 'Login is successful') {
        loginNotifier.clearState();
        ref.read(authControllerProvider).dispose();
        initialLocationNotifier.setInitialLocation('/home');
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
            context.go('/password-reset');
          },
          child: Text('Forgot Password?',
              style: GoogleFonts.nunito(
                fontSize: 13.0,
                color: Color.fromRGBO(0, 122, 255, 1),
                fontWeight: FontWeight.bold,
              )),
        ),
        buttonWidget: loginState.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: GoogleFonts.nunitoSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
