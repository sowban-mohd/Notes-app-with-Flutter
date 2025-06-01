import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/core/constants/constants.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/core/providers/shared_prefs_provider.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';
import 'package:notetakingapp1/features/auth/controller/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authControllerProvider.select((authState) => authState.generalError),
      (prev, next) {
        if (next != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next)),
            );
          });
        }
      },
    );

    ref.listen(userProvider, (prev, next) {
      next.whenData((next) async {
        if (next != null) {
          final prefs = ref.read(sharedPreferencesProvider);
          final homePath = Routes.homeScreen.path;
          final goRouterContext = GoRouter.of(context);
          await prefs.setString(Constants.initialLocationKey, homePath);
          goRouterContext.go(homePath);
        }
      });
    });

    final controllers = ref.watch(authFormControllers).loginFormControllers;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
          child: Column(
            children: [
              // Title, textfields (Scrollable part)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 330,
                      child: Column(
                        children: [
                          Text(
                            'Ready to get productive? Login',
                            style: Styles.titleStyle(fontSize: 32.0),
                          ),
                          const SizedBox(height: 42.0),
                          Consumer(builder: (context, ref, _) {
                            final emailError = ref.watch(authControllerProvider
                                .select((authState) => authState.emailError));
                            final isEmailError = emailError != null;
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email',
                                      style: Styles.w500texts(fontSize: 12.0)),
                                  const SizedBox(height: 7.0),
                                  Theme(
                                    data: Styles.textSelectionTheme(),
                                    child: SizedBox(
                                      height: 50,
                                      width: 330,
                                      child: TextField(
                                        controller: controllers.emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        onTap: ref
                                            .read(authControllerProvider.notifier)
                                            .clearState,
                                        decoration: Styles.textfieldDecoration(
                                          hintText: 'Email address',
                                          isError: isEmailError,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  if (emailError != null) ...[
                                    Text(emailError,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                            color: colorScheme.error)),
                                    const SizedBox(height: 6.0),
                                  ],
                                ]);
                          }),
                          Consumer(builder: (context, ref, _) {
                            final passwordError = ref.watch(
                                authControllerProvider.select(
                                    (authState) => authState.passwordError));
                            final isPasswordError = passwordError != null;
                            final isPasswordHidden =
                                ref.watch(passwordVisibilityProvider);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Password',
                                    style: Styles.w500texts(fontSize: 12.0)),
                                const SizedBox(height: 7.0),
                                Theme(
                                  data: Styles.textSelectionTheme(),
                                  child: SizedBox(
                                    height: 50,
                                      width: 330,
                                    child: TextField(
                                      controller: controllers.passwordController,
                                      obscureText: isPasswordHidden,
                                      onTap: ref
                                          .read(authControllerProvider.notifier)
                                          .clearState,
                                      decoration: Styles.textfieldDecoration(
                                        hintText: 'Password',
                                        isError: isPasswordError,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            ref
                                                    .read(
                                                        passwordVisibilityProvider
                                                            .notifier)
                                                    .state =
                                                !ref.read(
                                                    passwordVisibilityProvider);
                                          },
                                          icon: Icon(isPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    passwordError != null
                                        ? Flexible(
                                            child: Text(
                                              passwordError,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                  color: colorScheme.error),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    TextButton(
                                      onPressed: () {
                                        context.go(
                                            Routes.passwordResetScreen.path);
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: Styles.textButtonStyle(
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Authenticate button, text (Unscrollable part)
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await ref.read(authControllerProvider.notifier).login(
                              controllers.emailController.text.trim(),
                              controllers.passwordController.text.trim(),
                            );
                      },
                      style: Styles.elevatedButtonStyle(),
                      child: Consumer(builder: (context, ref, _) {
                        final isLoading = ref.watch(authControllerProvider
                            .select((authState) => authState.isLoading));
                        return isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login',
                                style: Styles.elevatedButtonTextStyle(),
                              );
                      })),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                          style: Styles.w500texts(
                              fontSize: 13.0, color: colorScheme.onSurface)),
                      TextButton(
                        onPressed: () {
                          context.go(Routes.signUpScreen.path);
                        },
                        child: Text(
                          'Sign Up',
                          style: Styles.textButtonStyle(fontSize: 13.0),
                        ),
                      ),
                    ],
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
