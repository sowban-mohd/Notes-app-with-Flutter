import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/features/auth/controller/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(authFormControllers).passwordResetController;
    final authController = ref.read(authControllerProvider.notifier);

    ref.listen<String?>(
      authControllerProvider.select((state) => state.generalError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        }
      },
    );

    ref.listen<String?>(
      authControllerProvider.select((state) => state.successMessage),
      (prev, next) {
        if (next == 'Password reset email sent') {
          context.go(Routes.accessConfirmationScreen.path);
        }
      },
    );

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 48.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            context.go(Routes.loginScreen.path);
                          },
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: colorScheme.primary),
                          label: Text(
                            "Back",
                            style: Styles.textButtonStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 64.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 330,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Forgot Password?',
                                textAlign: TextAlign.center,
                                style: Styles.titleStyle(fontSize: 32.0),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'Enter your registered email, and we\'ll send you instructions to reset your password',
                                style: Styles.subtitleStyle(fontSize: 14.0),
                              ),
                              const SizedBox(height: 42.0),

                              // Label
                              Text('Email',
                                  style: Styles.w500texts(fontSize: 12.0)),
                              const SizedBox(height: 10.0),

                              // TextField
                              Theme(
                                data: Styles.textSelectionTheme(),
                                child: Consumer(builder: (context, ref, _) {
                                  final isemailError = ref.watch(
                                      authControllerProvider.select(
                                          (authState) =>
                                              authState.emailError != null));
                                  return SizedBox(
                                    height: 50,
                                      width: 330,
                                    child: TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      onTap: () => authController.clearState(),
                                      decoration: Styles.textfieldDecoration(
                                          hintText: 'Email address',
                                          isError: isemailError),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 6.0),

                              // Email error text
                              Consumer(
                                builder: (context, ref, _) {
                                  final emailError = ref.watch(
                                      authControllerProvider
                                          .select((state) => state.emailError));
                                  return emailError != null
                                      ? Column(
                                          children: [
                                            Text(emailError,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                    color: colorScheme.error)),
                                            const SizedBox(height: 6.0),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  authController.passwordreset(emailController.text.trim());
                },
                style: Styles.elevatedButtonStyle(),
                child: Consumer(builder: (context, ref, _) {
                  final isLoading = ref.watch(authControllerProvider
                      .select((state) => state.isLoading));
                  return isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: Styles.elevatedButtonTextStyle(),
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
