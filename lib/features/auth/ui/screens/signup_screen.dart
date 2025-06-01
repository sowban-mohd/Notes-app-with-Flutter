import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/features/auth/controller/auth_form_controllers_provider.dart';
import 'package:notetakingapp1/core/providers/shared_prefs_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/auth/controller/auth_controller.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authControllerProvider.select((state) => state.generalError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        }
      },
    );

    ref.listen(
      userProvider,
      (prev, next) {
        next.whenData((next) async {
          if (next != null) {
            final prefs = ref.read(sharedPreferencesProvider);
            final homePath = Routes.homeScreen.path;
            await prefs.setString('InitialLocation', homePath);
            if (context.mounted) context.go(homePath);
          }
        });
      },
    );

    final controllers = ref.watch(authFormControllers).signUpFormControllers;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 330,
                      child: Column(
                        children: [
                          Text(
                            'Begin your notes taking adventure with us! Sign Up',
                            style: Styles.titleStyle(fontSize: 32.0),
                          ),
                          const SizedBox(height: 42.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email',
                                  style: Styles.w500texts(fontSize: 12.0)),
                              const SizedBox(height: 7.0),
                              Theme(
                                data: Styles.textSelectionTheme(),
                                child: Consumer(
                                  builder: (context, ref, _) {
                                    return SizedBox(
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
                                          isError: ref.watch(
                                              authControllerProvider.select(
                                                  (state) =>
                                                      state.emailError != null)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 6.0),
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
                              Text('Password',
                                  style: Styles.w500texts(fontSize: 12.0)),
                              const SizedBox(height: 7.0),
                              Theme(
                                data: Styles.textSelectionTheme(),
                                child: Consumer(
                                  builder: (context, ref, _) {
                                    final passwordError = ref.watch(
                                        authControllerProvider.select(
                                            (state) => state.passwordError));
                                    return SizedBox(
                                      height: 50,
                                      width: 330,
                                      child: TextField(
                                        controller:
                                            controllers.passwordController,
                                        obscureText:
                                            ref.watch(passwordVisibilityProvider),
                                        onTap: ref
                                            .read(authControllerProvider.notifier)
                                            .clearState,
                                        onChanged: (password) {
                                          ref
                                              .read(passwordStrengthProvider
                                                  .notifier)
                                              .evaluate(password);
                                        },
                                        decoration: Styles.textfieldDecoration(
                                          hintText: 'Password',
                                          isError: passwordError != null,
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
                                            icon: Icon(ref.watch(
                                                    passwordVisibilityProvider)
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  final passwordError = ref.watch(
                                      authControllerProvider.select(
                                          (state) => state.passwordError));
                                  final strength =
                                      ref.watch(passwordStrengthProvider);
                                  return Row(
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
                                          : const SizedBox.shrink(),
                                      passwordError == null && strength != null
                                          ? Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Strength : ',
                                                    style: Styles.universalFont(
                                                        color: colorScheme
                                                            .onSurface),
                                                  ),
                                                  TextSpan(
                                                    text: strength
                                                        .passwordStrength,
                                                    style: Styles.universalFont(
                                                      color: strength
                                                          .passwordStrengthColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signup(
                            controllers.emailController.text.trim(),
                            controllers.passwordController.text.trim(),
                          );
                    },
                    style: Styles.elevatedButtonStyle(),
                    child: Consumer(builder: (context, ref, _) {
                      final isLoading = ref.watch(authControllerProvider
                          .select((state) => state.isLoading));
                      return isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: Styles.elevatedButtonTextStyle(),
                            );
                    }),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: Styles.w500texts(
                              fontSize: 13.0, color: colorScheme.onSurface)),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(authControllerProvider.notifier)
                              .clearState();
                          context.go(Routes.loginScreen.path);
                        },
                        child: Text(
                          'Login',
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
