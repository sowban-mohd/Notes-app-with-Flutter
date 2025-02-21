import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import '../../../providers/auth_screen_providers/auth_state_provider.dart';
import '../../../providers/controllers_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(authControllerProvider).emailController;

    //Gets Access to authentication state and notifier
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    //Show error messages if any
    if (authState.generalError != null) {
      showSnackbarMessage(context, message: authState.generalError!);
    }

    // If password reset email has sent, navigate to the access confirmation screen
    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage == 'Password reset email sent') {
        context.go('/access-confirm');
      }
    });

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
                    //Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          authNotifier.clearState();
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
                    SizedBox(height: 64.0),
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
                            SizedBox(height: 12.0),
                            Text(
                              'Enter your registered email, and we\'ll send you instructions to reset your password',
                              style: Styles.subtitleStyle(fontSize: 16.0),
                            ),

                            SizedBox(height: 42.0),

                            // Label for textfield
                            Text('Email',
                                style: Styles.w500texts(fontSize: 14.0)),
                            const SizedBox(height: 10.0),

                            //Textfield
                            Theme(
                              data: Styles.textSelectionTheme(),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                onTap: authNotifier.clearState,
                                decoration: Styles.textfieldDecoration(
                                    hintText: 'Email address',
                                    error: authState.emailError),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            //Email error message
                            authState.emailError != null
                                ? Text(authState.emailError!,
                                    style: TextStyle(color: colorScheme.error))
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              ElevatedButton(
                onPressed: () {
                  authNotifier.passwordreset(emailController.text.trim());
                },
                style: Styles.elevatedButtonStyle(),
                child: authState.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
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
