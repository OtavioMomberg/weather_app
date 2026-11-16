import 'package:http/http.dart';
import 'package:weather_app/data/repositories/weather_implementation.dart';
import 'package:weather_app/ui/controllers/city_controller.dart';
import 'package:weather_app/data/repositories/city_implementation.dart';
import 'package:weather_app/ui/controllers/weather_controller.dart';

enum ControllerType { city, weather }

final class AppDi<T> {
  T getController({required ControllerType controllerType}) {
    switch (controllerType) {
      case .city:
        return CityController(
          respository: CityImplementation(client: Client()),
        ) as T;
      case .weather:
        return WeatherController(
          repository: WeatherImplementation(client: Client()),
        ) as T;
    }
  }
}