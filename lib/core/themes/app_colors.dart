import 'package:material_ui/material_ui.dart';

final class const AppColors._() {
  static const lightBlue = Color.fromARGB(255, 100, 185, 255);
  static const blue = Color.fromARGB(255, 53, 163, 252);
  static const blueDarker = Color.fromARGB(255, 55, 164, 253);
  static const whiteBlueish = Color.fromARGB(255, 188, 221, 255);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const red = Color.fromARGB(255, 223, 75, 75);

  static final colorScheme = ColorScheme(
    brightness: .light,
    primary: blue,
    onPrimary: whiteBlueish,
    secondary: lightBlue,
    onSecondary: whiteBlueish,
    error: red,
    onError: whiteBlueish,
    surface: white.withValues(alpha: .1),
    onSurface: whiteBlueish,
  );
}
