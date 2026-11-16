import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';

typedef Hour = List<HourByHourModel>;
typedef Forecast = List<ForecastModel>;
typedef Current = CurrentWeatherModel;

final class WeatherController({
  required final WeatherRepository repository,
}) {
  String? _errorGetWeather;
  String? get getErrorWeather => _errorGetWeather;

  final Hour _hourByHour = [];
  Hour get getHourByHour => _hourByHour;

  final Forecast _forecast = [];
  Forecast get getForecast => _forecast;

  Current _current = CurrentWeatherModel.empty();
  Current get getCurrent => _current;

  Future<void> onGetWeather({
    required String city, 
    String lang = "pt", 
    int days = 3
  }) async {
    _errorGetWeather = null;
    try {
      final response = await repository.getWeather(city: city);
      _hourByHour.addAll(response.hourByHourModel);
      _forecast.addAll(response.forecastModel);
      _current = response.currentWeatherModel;
    } catch (error) {
      _errorGetWeather = error.toString();
    }
  }
}