import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';

final class WeatherController({
  required final WeatherRepository repository,
}) {
  String? _errorGetWeather;
  String? get getErrorWeather => _errorGetWeather;

  WeatherModel? _weatherModel;
  WeatherModel get getWether => _weatherModel!;

  Future<void> onGetWeather({
    required String city, 
    String lang = "pt", 
    int days = 3
  }) async {
    _errorGetWeather = null;
    try {
      final response = await repository.getWeather(city: city);
      _weatherModel = response;
    } catch (error) {
      _errorGetWeather = error.toString();
    }
  }
}