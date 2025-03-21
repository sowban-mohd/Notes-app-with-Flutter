/// Handles Firebase related authentication errors by creating user-friendly error messages
Map<String, String?> handleAuthError(String errorCode) {
  switch (errorCode) {
    case 'email-already-in-use':
      return {'emailError': 'This email is already in use.'};
    case 'invalid-credential':
      return {'generalError': 'Invalid credentials'};
    case 'invalid-email':
      return {'emailError': 'Please enter a valid email.'};
    case 'weak-password':
      return {'passwordError': 'Password is too weak.'};
    case 'user-not-found':
      return {'emailError': 'No account found with this email.'};
    case 'wrong-password':
      return {'passwordError': 'Incorrect password.'};
    case 'user-disabled':
      return {'emailError': 'Your account has been disabled.'};
    case 'too-many-requests':
      return {'generalError': 'Too many failed attempts.'};
    case 'network-request-failed':
      return {'generalError': 'Check your internet connection.'};
    default:
      return {'generalError': 'Something went wrong. Please try again.'};
  }
}
