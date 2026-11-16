import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/ui/controllers/weather_controller.dart';

typedef Controller = AppDi<WeatherController>;

const defaultCity = "São Paulo";

final class DataSourceService._() {
  static final _instance = DataSourceService._();
  factory instance() => _instance;

  final weatherController = Controller().
    getController(controllerType: .weather);

  Future<void> run() async {
    await weatherController.onGetWeather(
      city: CityStorage.instance().cityName ?? defaultCity
    );
  }
}