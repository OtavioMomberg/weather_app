import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/ui/home_screen.dart';
import 'package:weather_app/ui/select_city_screen.dart';

final class AppGate._() { 
  static final cityStorage = CityStorage.instance();

  static Widget getScreen() {
    if (cityStorage.cityName != null) {
      return const HomeScreen();
    }
    return const SelectCityScreen();
  }
}