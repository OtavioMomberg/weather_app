import 'package:http/http.dart';
import 'package:weather_app/controllers/city_controller.dart';
import 'package:weather_app/data/repositories/city_implementation.dart';

enum ControllerType { city }

final class AppDi<T> {
  T getController({required ControllerType controllerType}) {
    switch (controllerType) {
      case .city:
        return CityController(
        respository: CityImplementation(client: Client()),
      ) as T;
    }
  }
}