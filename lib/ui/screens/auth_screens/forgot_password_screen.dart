import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_screen_providers.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(authControllerProvider).emailController;
    final authStateNotifier = ref.read(authStateProvider.notifier);
    final emailErrorState =
        ref.watch(authStateProvider.select((state) => state.emailError));

    ref.listen<String?>(
      authStateProvider.select((state) => state.generalError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        }
      },
    );

    ref.listen<String?>(
      authStateProvider.select((state) => state.successMessage),
      (prev, next) {
        if (next == 'Password reset email sent') {
          context.go('/access-confirm');
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
                            authStateNotifier.clearState();
                            context.go('/login');
                          },
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: colorScheme.primary),
                          label: Text(
                            "Back",
                            style: Styles.textButtonStyle(fontSize: 16.0),
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
                                style: Styles.titleStyle(fontSize: 36.0),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'Enter your registered email, and we\'ll send you instructions to reset your password',
                                style: Styles.subtitleStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 42.0),

                              // Label
                              Text('Email',
                                  style: Styles.w500texts(fontSize: 14.0)),
                              const SizedBox(height: 10.0),

                              // TextField
                              Theme(
                                data: Styles.textSelectionTheme(),
                                child: TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  onTap: () => authStateNotifier.clearState(),
                                  decoration: Styles.textfieldDecoration(
                                      hintText: 'Email address',
                                      error: emailErrorState),
                                ),
                              ),
                              const SizedBox(height: 6.0),

                              // Email error text
                              if (emailErrorState != null)
                                Text(
                                  emailErrorState,
                                  style: TextStyle(color: colorScheme.error),
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
                  authStateNotifier.passwordreset(emailController.text.trim());
                },
                style: Styles.elevatedButtonStyle(),
                child: ref.watch(
                        authStateProvider.select((state) => state.isLoading))
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Continue',
                        style: Styles.elevatedButtonTextStyle(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
