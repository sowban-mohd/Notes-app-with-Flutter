import 'package:flutter/material.dart';

/// Generates color scheme for the app
// Not applied in MaterialApp's theme property, but used as needed
ColorScheme customColorscheme() {
  return ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(0, 122, 255, 1),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(247, 206, 69, 1),
    onSecondary: Colors.white,
    tertiary: Colors.grey,
    onTertiary: Colors.white,
    error: Color.fromRGBO(235, 77, 61, 1),
    onError: Colors.white,
    surface: Color.fromRGBO(242, 242, 246, 1),
    onSurface: Color.fromRGBO(28, 33, 33, 1),
    onInverseSurface: Colors.white,
    onSurfaceVariant: Color.fromRGBO(60, 60, 67, 0.7),
    surfaceContainer: Colors.white,
    surfaceContainerLowest: Colors.white,
    outline: Colors.grey,
    outlineVariant: Colors.black54,
  );
}
