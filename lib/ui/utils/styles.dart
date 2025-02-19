import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  /// Style for elevated buttons
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(304, 56),
      backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  /// Style for texts in elevatedbuttons
  static TextStyle elevatedButtonTextStyle() {
    return GoogleFonts.nunitoSans(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  /// Style for text buttons
  static TextStyle textButtonStyle() {
    return GoogleFonts.nunitoSans(
      color: Color.fromRGBO(0, 122, 255, 1),
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
  }

  /// Style for title texts
  static TextStyle titleStyle({required double fontSize}) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  ///Style for subtitle texts
  static TextStyle subtitleStyle({required double fontSize}) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      color: Colors.black.withValues(alpha: 51.0),
    );
  }

  ///Theme for selection inside a textfield
  static ThemeData textSelectionTheme() {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.blue.withAlpha(51),
        selectionHandleColor: Colors.blue,
      ),
    );
  }

  ///Textfield decoration for textfields in authentication screens
  static InputDecoration textfieldDecoration({
    required String hintText,
    IconButton? suffixIcon,
    required String? error,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.nunito(),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: error != null ? Colors.red : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: error != null ? Colors.red : Colors.blue, width: 2.0),
      ),
    );
  }

  /// Style for textfield labels
  static TextStyle textfieldLabelStyle() {
    return GoogleFonts.nunito(fontSize: 14.0, fontWeight: FontWeight.w500);
  }
}
