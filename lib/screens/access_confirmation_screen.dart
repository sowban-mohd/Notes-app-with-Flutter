import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/controllers_provider.dart';
import '../providers/auth_state_provider.dart';

class AccessConfirmationScreen extends ConsumerWidget {
  const AccessConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController =
        ref.watch(controllersProvider).forgotPasswordController.emailController;
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Access Confirmation',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 18.0),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: 'We have sent a confirmation email to ',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                              color: Colors.black.withValues(alpha: 25.0),
                            )),
                        TextSpan(
                            text: emailController.text.trim(),
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold, fontSize: 16.0))
                      ])),
                      SizedBox(height: 18.0),
                      Text(
                        'Kindly check your inbox and click on the link to reset your password',
                        style: GoogleFonts.nunito(
                          fontSize: 16.0,
                          color: Colors.black.withValues(alpha: 25.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  authNotifier.passwordreset(emailController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(304, 56),
                  backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
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
                        'Resend link',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Have reset your password?',
                      style: GoogleFonts.nunito(
                          fontSize: 15.0, fontWeight: FontWeight.w500)),
                  TextButton(
                    onPressed: () {
                      authNotifier.clearError();
                      context.go('/login');
                    },
                    child: Text(
                      'Login now',
                      style: GoogleFonts.nunito(
                        fontSize: 14.0,
                        color: const Color.fromRGBO(0, 122, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
