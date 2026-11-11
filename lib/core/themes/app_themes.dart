import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/core/themes/app_colors.dart';

final class const AppThemes._() {
  static const gradient = LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [AppColors.lightBlue, AppColors.blue, AppColors.blueDarker],
  );

  static final appBar = AppBarTheme(
    toolbarHeight: 0,
    surfaceTintColor: Colors.transparent,
    backgroundColor: AppColors.lightBlue,
    foregroundColor: AppColors.whiteBlueish,
    systemOverlayStyle: systemUiOverlayStyle,
  );

  static const systemUiOverlayStyle = SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: false,
    statusBarColor: AppColors.lightBlue,
    statusBarIconBrightness: .dark,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: AppColors.blueDarker,
    systemNavigationBarIconBrightness: .dark,
  );

  static const iconTheme = IconThemeData(
    color: AppColors.whiteBlueish,
    size: 20,
  );

  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      color: AppColors.whiteBlueish,
      fontWeight: .bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: AppColors.whiteBlueish,
      fontWeight: .bold,
    ),
    labelSmall: TextStyle(fontSize: 12, color: AppColors.whiteBlueish),
  );

  static final themeData = ThemeData(
    colorScheme: AppColors.colorScheme,
    appBarTheme: appBar,
    brightness: .light,
    scaffoldBackgroundColor: AppColors.blueDarker,
    iconTheme: iconTheme,
    textTheme: textTheme,
  );
}