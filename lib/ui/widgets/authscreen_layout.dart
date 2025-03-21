import 'package:flutter/material.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class AuthScreenLayout extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String title;
  final String? emailError;
  final String? passwordError;
  final VoidCallback clearErrorFunction;
  final bool isPasswordHidden;
  final VoidCallback visibilityOnPressed;
  final void Function(String)? strengthEvaluateFunction;
  final Widget belowPassword;
  final Widget buttonWidget;
  final VoidCallback onSubmit;
  final String bottomText;
  final String toggleText;
  final VoidCallback onToggle;

  const AuthScreenLayout({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.title,
    required this.emailError,
    required this.passwordError,
    required this.clearErrorFunction,
    this.strengthEvaluateFunction,
    required this.isPasswordHidden,
    required this.visibilityOnPressed,
    required this.belowPassword,
    required this.buttonWidget,
    required this.onSubmit,
    required this.bottomText,
    required this.toggleText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
          child: Column(
            children: [
              //Title, textfields (Scrollable part)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 330,
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: Styles.titleStyle(fontSize: 36.0),
                          ),
                          const SizedBox(height: 42.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Email label
                                Text('Email',
                                    style: Styles.w500texts(fontSize: 14.0)),
                                const SizedBox(height: 7.0),
                                //Email Textfield
                                Theme(
                                  data: Styles.textSelectionTheme(),
                                  child: TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      onTap: clearErrorFunction,
                                      decoration: Styles.textfieldDecoration(
                                          hintText: 'Email address',
                                          error: emailError)),
                                ),
                                const SizedBox(height: 6.0),
                                //Email error message
                                emailError != null
                                    ? Text(emailError!,
                                        style:
                                            TextStyle(color: colorScheme.error))
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16.0),
                                //Password label
                                Text('Password',
                                    style: Styles.w500texts(fontSize: 14.0)),
                                const SizedBox(height: 7.0),
                                //Password Textfield
                                Theme(
                                  data: Styles.textSelectionTheme(),
                                  child: TextField(
                                      controller: passwordController,
                                      obscureText: isPasswordHidden,
                                      onTap: clearErrorFunction,
                                      onChanged: strengthEvaluateFunction,
                                      decoration: Styles.textfieldDecoration(
                                        hintText: 'Password',
                                        error: passwordError,
                                        suffixIcon: IconButton(
                                          onPressed: visibilityOnPressed,
                                          icon: Icon(isPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                      )),
                                ),
                                //Passwor error message, forgot password button/password strength indicator
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    passwordError != null
                                        ? Text(
                                            passwordError!,
                                            style: TextStyle(
                                                color: colorScheme.error),
                                          )
                                        : const SizedBox.shrink(),
                                    belowPassword
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //Authenticate button, text (Unscrollable part)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: onSubmit,
                    style: Styles.elevatedButtonStyle(),
                    child: buttonWidget,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bottomText,
                          style: Styles.w500texts(fontSize: 14.0, color: colorScheme.onSurface)),
                      TextButton(
                        onPressed: onToggle,
                        child: Text(
                          toggleText,
                          style: Styles.textButtonStyle(fontSize: 14.0),
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
