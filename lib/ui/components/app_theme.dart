import 'package:flutter/material.dart';

ThemeData makeAppDefaultTheme() {
  final primaryColor = Color.fromRGBO(136, 14, 70, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final primaryColorDisabled = Color.fromRGBO(188, 71, 123, .4);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    accentColor: primaryColor,
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
      button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
    ),
    buttonTheme: ButtonThemeData(
        minWidth: double.infinity,
        height: 50,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onSurface: primaryColorDisabled,
        ),
        buttonColor: primaryColor,
        splashColor: primaryColorLight,
        disabledColor: primaryColorDisabled,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
  );
}
