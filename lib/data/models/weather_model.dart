import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';

final class const WeatherModel({
  required final CurrentWeatherModel currentWeatherModel,
  required final List<HourByHourModel> hourByHourModel,
  required final List<ForecastModel> forecastModel,
});