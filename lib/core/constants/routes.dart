enum Routes {
  onBoardingScreen('/welcome'),
  loginScreen('/login'),
  signUpScreen('/signup'),
  passwordResetScreen('/password-reset'),
  accessConfirmationScreen('access-confirm'),
  homeScreen('/home');

  final String path;
  const Routes(this.path);
}
