import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const WeatherModel({
  required final String name,
  required final double temperature,
  required final double maxTemp,
  required final double minTemp,
  required final String condition,
  required final int pressureMB,
  required final int humidity,
  required final double feelslike,
  required final double uvIndex,
  required final DateTime lastUpdated,
}) {
  factory fromMap({required MSD map}) {
    final current = map["current"] as MSD;
    final forecast = map["forecast"]["forecastday"][0]["day"] as MSD; 

    return WeatherModel(
      name: map["location"]["name"] as String, 
      temperature: current["temp_c"] as double, 
      maxTemp: forecast["maxtemp_c"] as double, 
      minTemp: forecast["mintemp_c"] as double, 
      feelslike: current["feelslike_c"] as double, 
      condition: current["condition"]["text"] as String, 
      pressureMB: current["pressure_mb"] as int, 
      humidity: current["humidity"] as int, 
      uvIndex: current["uv"] as double,
      lastUpdated: current["last_updated"] as DateTime,
    );
  }

  factory fromJson({required String source}) =>
    WeatherModel.fromMap(map: jsonDecode(source));
}