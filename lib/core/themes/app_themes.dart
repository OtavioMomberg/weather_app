import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/core/themes/app_colors.dart';

final class const AppThemes._() {
  static const gradient = LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [AppColors.lightBlue, AppColors.blue, AppColors.darkBlue],
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
    systemNavigationBarColor: AppColors.darkBlue,
    systemNavigationBarIconBrightness: .dark,
  );

  static const iconTheme = IconThemeData(
    color: AppColors.whiteBlueish,
    size: 20,
  );

  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 70,
      color: AppColors.whiteBlueish,
      fontWeight: .bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: AppColors.whiteBlueish,
      fontWeight: .bold,
    ),
    labelSmall: TextStyle(fontSize: 14, color: AppColors.whiteBlueish),
  );

  static final themeData = ThemeData(
    colorScheme: AppColors.colorScheme,
    appBarTheme: appBar,
    brightness: .light,
    scaffoldBackgroundColor: AppColors.darkBlue,
    splashColor: AppColors.lightBlue.withValues(alpha: .2),
    highlightColor: AppColors.lightBlue.withValues(alpha: .5),
    iconTheme: iconTheme,
    textTheme: textTheme,
    fontFamily: "ShareTech",
  );

  static const stdPadding = EdgeInsets.all(10);
  static const midPadding = EdgeInsets.all(14);

  static const stdBorderRadius = BorderRadius.all(.circular(12));
  static const searchBarBorderRadius = BorderRadius.all(.circular(20));

  static const searchBorder = RoundedRectangleBorder(
    borderRadius: searchBarBorderRadius,
    side: BorderSide(color: AppColors.whiteBlueish),
  );
}
