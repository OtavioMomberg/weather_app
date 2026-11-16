import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const CurrentWeatherModel({
  required final String name,
  required final double temperature,
  required final double maxTemp,
  required final double minTemp,
  required final String condition,
  required final double pressureMB,
  required final int humidity,
  required final double feelslike,
  required final double uvIndex,
  required final String lastUpdated,
}) {
  factory empty() { 
    return CurrentWeatherModel(
      name: "", 
      temperature: 0, 
      maxTemp: 0, 
      minTemp: 0, 
      condition: "", 
      pressureMB: 0, 
      humidity: 0, 
      feelslike: 0, 
      uvIndex: 0, 
      lastUpdated: "",
    );
  }

  factory fromMap({required MSD map}) {
    final current = map["current"] as MSD;
    final forecast = map["forecast"]["forecastday"][0]["day"] as MSD; 

    return CurrentWeatherModel(
      name: map["location"]["name"] as String, 
      temperature: current["temp_c"] as double, 
      maxTemp: forecast["maxtemp_c"] as double, 
      minTemp: forecast["mintemp_c"] as double, 
      feelslike: current["feelslike_c"] as double, 
      condition: current["condition"]["text"] as String, 
      pressureMB: current["pressure_mb"] as double, 
      humidity: current["humidity"] as int, 
      uvIndex: current["uv"] as double,
      lastUpdated: current["last_updated"] as String,
    );
  }

  factory fromJson({required String source}) =>
    CurrentWeatherModel.fromMap(map: jsonDecode(source));
}