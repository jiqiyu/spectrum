import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color appBarColour = Color(0xFFe9e9e9);

var appTheme = ThemeData(
  fontFamily: GoogleFonts.notoSansDevanagari().fontFamily,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: appBarColour,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    color: appBarColour,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      // fontFamily: GoogleFonts.outfit().fontFamily,
    ),
    toolbarHeight: 60,
  ),
  brightness: Brightness.light,
  // textTheme: const TextTheme(
  //   bodyText1: TextStyle(fontSize: 18),
  //   bodyText2: TextStyle(fontSize: 16),
  //   button: TextStyle(
  //     letterSpacing: 1.5,
  //     fontWeight: FontWeight.bold,
  //   ),
  //   headline1: TextStyle(
  //     fontWeight: FontWeight.bold,
  //   ),
  //   subtitle1: TextStyle(
  //     color: Colors.grey,
  //   ),
  // ),
  buttonTheme: const ButtonThemeData(),
);
