import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fonts.gen.dart';

class Themes {
  const Themes._();

  static const secondaryColor = Color(0xFF001489);
  static const primaryColor = Color(0xFF2A2E33);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColorDark: secondaryColor,
        primaryColorLight: secondaryColor,
        fontFamily: FontFamily.sFProRounded,
        canvasColor: CupertinoColors.white,
        dividerColor: CupertinoColors.systemFill,
        scaffoldBackgroundColor: CupertinoColors.white,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          isCollapsed: true,
          border: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          clipBehavior: Clip.antiAlias,
          backgroundColor: CupertinoColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CupertinoColors.systemFill.withOpacity(0.1)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: CupertinoColors.systemGrey4,
          backgroundColor: CupertinoColors.black,
        ),
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(barBackgroundColor: CupertinoColors.white),
        dividerTheme: const DividerThemeData(space: 0.8, thickness: 0.8),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: primaryColor,
        indicatorColor: secondaryColor,
        fontFamily: FontFamily.sFProRounded,
        dividerColor: CupertinoColors.systemFill,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          isDense: true,
          isCollapsed: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide.none,
            gapPadding: 0.0,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          clipBehavior: Clip.antiAlias,
          backgroundColor: CupertinoColors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: CupertinoColors.darkBackgroundGray),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        ),
        dividerTheme: const DividerThemeData(space: 0.8, thickness: 0.8),
      );
}
