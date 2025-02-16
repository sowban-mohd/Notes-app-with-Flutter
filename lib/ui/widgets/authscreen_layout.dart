import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.white,
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
                            style: GoogleFonts.nunitoSans(
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 42.0),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Email label
                                Text('Email',
                                    style: GoogleFonts.nunito(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 7.0),
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
                                    onTap: clearErrorFunction,
                                    decoration: InputDecoration(
                                      hintText: 'Email address',
                                      hintStyle: GoogleFonts.nunito(),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: emailError != null
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: emailError != null
                                                ? Colors.red
                                                : Colors.blue,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                //Email error message
                                emailError != null
                                    ? Text(emailError!,
                                        style:
                                            const TextStyle(color: Colors.red))
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16.0),
                                //Password label
                                Text('Password',
                                    style: GoogleFonts.nunito(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 7.0),
                                //Password Textfield
                                Theme(
                                  data: ThemeData(
                                    textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: Colors.blue,
                                      selectionColor: Colors.blue.withAlpha(51),
                                      selectionHandleColor: Colors.blue,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: isPasswordHidden,
                                    onTap: clearErrorFunction,
                                    onChanged: strengthEvaluateFunction,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: GoogleFonts.nunito(),
                                      suffixIcon: IconButton(
                                        onPressed: visibilityOnPressed,
                                        icon: Icon(isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: passwordError != null
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: passwordError != null
                                                ? Colors.red
                                                : Colors.blue,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                //Passwor error message, forgot password button/password strength indicator
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    passwordError != null
                                        ? Text(
                                            passwordError!,
                                            style: TextStyle(color: Colors.red),
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(304, 56),
                      backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: buttonWidget,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bottomText,
                          style: GoogleFonts.nunito(
                              fontSize: 15.0, fontWeight: FontWeight.w500)),
                      TextButton(
                        onPressed: onToggle,
                        child: Text(
                          toggleText,
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
            ],
          ),
        ),
      ),
    );
  }
}
