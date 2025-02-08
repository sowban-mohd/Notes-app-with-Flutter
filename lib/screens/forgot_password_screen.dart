import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetakingapp1/providers/auth_state_provider.dart';
import 'package:notetakingapp1/providers/controllers_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController =
        ref.watch(controllersProvider).forgotPasswordController.emailController;
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
   
    ref.listen(authStateProvider, (previous, next){
      if(next.successMessage == 'Password reset email sent'){
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
                          authNotifier.clearError();
                          context.go('/login');
                        },
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.blue),
                        label: Text(
                          "Back",
                          style: GoogleFonts.nunitoSans(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 36.0, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Enter your registered email, and we\'ll send you instructions to reset your password',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                color: Colors.black.withValues(alpha: 25.0),
                              ),
                            ),

                            SizedBox(height: 42.0),

                            //Email label
                            Text('Email',
                                style: GoogleFonts.nunito(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10.0),
                            //Email Textfield
                            Theme(
                              data: ThemeData(
                                textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: Colors.blue,
                                  selectionColor: Colors.blue.withAlpha(51),
                                  selectionHandleColor: Colors.blue,
                                ),
                              ),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                onTap: authNotifier.clearError,
                                decoration: InputDecoration(
                                  hintText: 'Email address',
                                  hintStyle: GoogleFonts.nunito(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: authState.emailError != null
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: authState.emailError != null
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 2.0),
                                  ),
                                ),
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
                        'Continue',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
