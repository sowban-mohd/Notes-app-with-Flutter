import 'package:flutter/material.dart';
import 'package:notetakingapp1/core/theme/colorscheme.dart';

final colorScheme = customColorscheme();

/// Contains methods that applies certain styles to widgets
class Styles {
  /// Generates textstyle with universal font of the app
  static TextStyle universalFont(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle( fontFamily: 'NunitoSans',
        fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
  
  ///Generates textstyle with respective fontweights
  
  static TextStyle w300texts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.w300, fontSize: fontSize, color: color);
  }

  static TextStyle w400texts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.w400, fontSize: fontSize, color: color);
  }

  static TextStyle w500texts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.w500, fontSize: fontSize, color: color);
  }

  static TextStyle w600texts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.w600, fontSize: fontSize, color: color);
  }

  static TextStyle w700texts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.w700, fontSize: fontSize, color: color);
  }

  static TextStyle boldTexts({Color? color, double? fontSize}) {
    return universalFont(fontWeight: FontWeight.bold, fontSize: fontSize, color: color);
  }

  /// Style for elevated buttons
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(250, 50),
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  /// Style for texts in elevatedbuttons
  static TextStyle elevatedButtonTextStyle() {
    return w700texts(
      fontSize: 16,
      color: colorScheme.onPrimary,
    );
  }

  /// Style for text buttons
  static TextStyle textButtonStyle({required double fontSize}) {
    return boldTexts(
      color: colorScheme.primary,
      fontSize: fontSize,
    );
  }

  /// Style for title texts
  static TextStyle titleStyle({double? fontSize, Color? color}) {
    return w700texts(
      fontSize: fontSize,
      color: color,
    );
  }

  ///Style for subtitle texts
  static TextStyle subtitleStyle({required double fontSize}) {
    return universalFont(
        fontSize: fontSize, color: colorScheme.onSurface);
  }

  ///Style for notes sections
  static TextStyle noteSectionTitle(){
    return boldTexts(fontSize: 12.0);
  }

  ///Theme for selection inside a textfield
  static ThemeData textSelectionTheme() {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withAlpha(51),
        selectionHandleColor: colorScheme.primary,
      ),
    );
  }

  ///Textfield decoration for textfields in authentication screens
  static InputDecoration textfieldDecoration({
    required String hintText,
    IconButton? suffixIcon,
    required bool isError,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: universalFont(fontSize: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isError ? colorScheme.error : colorScheme.outline,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
            color: isError ? colorScheme.error : colorScheme.primary,
            width: 2.0),
      ),
    );
  }
}
