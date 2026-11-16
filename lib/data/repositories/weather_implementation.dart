import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';

final class WeatherImplementation({
  required final Client _client,
}) implements WeatherRepository {
  @override
  Future<WeatherModel> getWeather({
    required String city, 
    String lang = "pt", 
    int days = 3
  }) async {
    final domain = weatherURL
      .replaceFirst("https://", "")
      .replaceFirst("/v1/forecast.json", "");
    final path = weatherURL.replaceFirst("https://api.weatherapi.com", "");
    final q = {
      "key": dotenv.get("API_KEY"), 
      "q": city,
      "lang": lang,
      "days": days.toString(),
    };
    final url = Uri.https(domain, path, q);
    final headers = {
      "Content-Type": "application/json",
      "X-Android-Package": dotenv.get("PACKAGE_ID"),
    };
    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final current = CurrentWeatherModel.fromJson(source: response.body);
      final hours = HourByHourModel.fromJson(source: response.body);
      final forecast = ForecastModel.fromJson(source: response.body);
      
      return WeatherModel(
        currentWeatherModel: current, 
        hourByHourModel: hours, 
        forecastModel: forecast,
      );
    }
    throw Exception(response.body);
  }
}