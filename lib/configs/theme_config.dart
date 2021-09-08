import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

class ThemeConfig {
  static get themeData {
    var theme = ThemeData(primarySwatch: Colors.blue);
    return theme.copyWith(
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        iconTheme: IconThemeData(color: COLOR_2f3130),
        color: Colors.white,
        textTheme: theme.textTheme.copyWith(
          headline6: theme.textTheme.headline6?.copyWith(
              fontSize: 18.0, fontWeight: BoldWeight, color: COLOR_2f3130),
        ),
      ),
      hintColor: Color(0xFF333333),
      errorColor: Colors.transparent,
      cupertinoOverrideTheme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(primaryColor: COLOR_EEEEEE),
          brightness: Brightness.dark,
          primaryColor: Color(0xFF222222),
          scaffoldBackgroundColor: Color(0xFFF4F4F4)),
      textSelectionTheme: theme.textSelectionTheme.copyWith(cursorColor: COLOR_E7E7E7),
      accentColor: Color(0xFFF3F3F3),
      textSelectionColor: Colors.black54.withAlpha(60),
      textSelectionHandleColor: Colors.black54.withAlpha(60),
      toggleableActiveColor: Colors.black54,
      chipTheme: theme.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: theme.textTheme.caption,
        backgroundColor: theme.chipTheme.backgroundColor.withOpacity(0.1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 14),
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      buttonTheme: theme.buttonTheme
          .copyWith(splashColor: Colors.transparent, padding: EdgeInsets.zero),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
