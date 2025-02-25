import 'package:flutter/material.dart';

/// Shows a snackbar message after the first frame is drawn
void showSnackbarMessage(context, {required String message}){
  WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
}

bool isDesktop(context) => MediaQuery.sizeOf(context).width >= 1100;
bool isTablet(context) => MediaQuery.sizeOf(context).width >= 500;
