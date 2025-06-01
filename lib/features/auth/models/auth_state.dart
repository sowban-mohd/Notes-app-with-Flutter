/// Manages the Authentication State
class AuthState {
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final String? successMessage;
  final bool isLoading;

  AuthState(
      {this.emailError,
      this.passwordError,
      this.generalError,
      this.successMessage,
      required this.isLoading});
}
