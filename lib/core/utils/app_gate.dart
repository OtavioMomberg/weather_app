import 'package:material_ui/material_ui.dart';
import 'package:weather_app/ui/screens/home_screen.dart';
import 'package:weather_app/ui/screens/select_city_screen.dart';

final class AppGate._() { 
  static Widget getScreen({String? cityName}) {
    if (cityName != null) {
      return const HomeScreen();
    }
    return const SelectCityScreen();
  }
}