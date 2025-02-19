import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
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

    if (authState.generalError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.generalError!),
          ),
        );
      });
    }

    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage == 'Password reset email sent') {
        context.go('/access-confirm');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          authNotifier.clearState();
                          context.go('/login');
                        },
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.blue),
                        label: Text(
                          "Back",
                          style: Styles.textButtonStyle(),
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

                            Text('Email', style: Styles.textfieldLabelStyle()),
                            const SizedBox(height: 10.0),
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
                                    style: const TextStyle(color: Colors.red))
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
