import 'package:weather_app/data/models/weather_model.dart';

abstract interface class WeatherRepository {
  Future<WeatherModel> getWeather({
    required String city,
    String lang = "pt",
    int days = 3,
  });
}