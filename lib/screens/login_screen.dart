import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    if (authState.generalError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.generalError!),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: 330,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ready to get productive? Login',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 36.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 42.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email',
                              style: GoogleFonts.nunito(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              )),
                          SizedBox(height: 7.0),
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
                                )),
                          ),
                          const SizedBox(height: 6.0),
                          authState.emailError != null
                              ? Text(
                                  authState.emailError!,
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 16.0),
                          Text('Password',
                              style: GoogleFonts.nunito(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                              )),
                          SizedBox(height: 7.0),
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
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: GoogleFonts.nunito(),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: authState.passwordError != null
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      color: authState.passwordError != null
                                          ? Colors.red
                                          : Colors.blue,
                                      width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              authState.passwordError != null
                                  ? Text(
                                      authState.passwordError!,
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : const SizedBox.shrink(),
                              TextButton(
                                onPressed: () {
                                  //Navigate to forgot password screen
                                },
                                child: Text('Forgot Password?',
                                    style: GoogleFonts.nunito(
                                      fontSize: 13.0,
                                      color: Color.fromRGBO(0, 122, 255, 1),
                                      fontWeight: FontWeight.bold,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 42),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authNotifier.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(304, 56),
                      backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                          style: GoogleFonts.nunito(
                              fontSize: 15.0, fontWeight: FontWeight.w500)),
                      TextButton(
                          onPressed: () {
                            //Navigate to signup screen
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.nunito(
                              fontSize: 14.0,
                              color: Color.fromRGBO(0, 122, 255, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
