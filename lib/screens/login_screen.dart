import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetakingapp1/widgets/reusable_authscreen_layout.dart';
import '../providers/auth_state_provider.dart';
import '../providers/login_screen_controllers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(signupStateProvider);
    final loginNotifier = ref.read(signupStateProvider.notifier);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final isPasswordHidden = ref.watch(passwordVisibilityProvider);

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

    return AuthScreenLayout(
        emailController: emailController,
        passwordController: passwordController,
        title: 'Ready to get productive? Login',
        emailError: loginState.emailError,
        passwordError: loginState.passwordError,
        clearErrorFunction: loginNotifier.clearError,
        isPasswordHidden: isPasswordHidden,
        visibilityOnPressed: () {
          ref.read(passwordVisibilityProvider.notifier).state =
              !isPasswordHidden;
        },
        belowPassword: TextButton(
          onPressed: () {
            //Navigate to forgot password screen
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
        onSubmit: () async {
          loginNotifier.authenticate(
              emailController.text.trim(), passwordController.text.trim());
        },
        bottomText: 'Don\'t have an account?',
        toggleText: 'Sign Up',
        onToggle: () {
          loginNotifier.clearError();
          context.go('/SignUpScreen');
        });
  }
}
