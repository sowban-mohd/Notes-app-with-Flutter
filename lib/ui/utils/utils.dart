import 'package:flutter/material.dart';

/// Shows a snackbar message after the first frame is drawn
void showSnackbarMessage(context, {required String message}){
  WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
}