import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single source of truth for the app's typography family.
///
/// **To swap the entire app font:** change the implementation of [primary] and
/// [applyPrimary] below. Every style in [AppTextStyles] and every `Text` that
/// uses a themed style will pick up the new font.
///
/// [editorial] is the serif accent used only for aurora headings (e.g. the
/// Cover hero on the home screen). It intentionally contrasts the primary
/// family and should not be used for body copy.
class AppFonts {
  AppFonts._();

  /// Primary app font — DM Sans. Wraps [GoogleFonts.roboto] so every style
  /// funnels through a single function.
  static TextStyle primary({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) =>
      GoogleFonts.roboto(
        textStyle: textStyle,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      );

  /// Editorial serif — Playfair Display. Used for aurora hero headings only.
  static TextStyle editorial({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.playfairDisplay(
        textStyle: textStyle,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        height: height,
      );

  /// Wraps a [TextTheme] so every entry uses the primary font. Call this in
  /// [AppTheme] when constructing light and dark themes.
  static TextTheme applyPrimary(TextTheme base) =>
      GoogleFonts.robotoTextTheme(base);
}
