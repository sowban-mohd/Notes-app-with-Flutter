import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/features/auth/controller/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';

class AccessConfirmationScreen extends ConsumerWidget {
  const AccessConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(authFormControllers).passwordResetController;
    final authController = ref.read(authControllerProvider.notifier);

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
                        style: Styles.titleStyle(fontSize: 36.0),
                      ),
                      const SizedBox(height: 18.0),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'We have sent a confirmation email to ',
                          style: Styles.subtitleStyle(fontSize: 14.0),
                        ),
                        TextSpan(
                          text: emailController.text.trim(),
                          style: Styles.boldTexts(fontSize: 16.0),
                        )
                      ])),
                      const SizedBox(height: 18.0),
                      Text(
                        'Kindly check your inbox and click on the link to reset your password',
                        style: Styles.subtitleStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

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
                          'Resend Link',
                          style: Styles.elevatedButtonTextStyle(),
                        );
                }),
              ),

              const SizedBox(height: 8.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Text('Have reset your password?',
                      style: Styles.w500texts(fontSize: 14.0)),
                  TextButton(
                    onPressed: () {
                      context.go(Routes.loginScreen.path);
                    },
                    child: Text(
                      'Login now',
                      style: Styles.textButtonStyle(fontSize: 13.0),
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
