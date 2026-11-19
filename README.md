# Weather App ⛅

This project is a weather app, with the purpose of apply good practices of Flutter applications, dealing with API and handling errors.

# Features ⚙️

- Current Temperature (°C)
- Min temperature for the day (°C)
- Max temperature for the day (°C)
- 24 hours forecast with (average temperature) (°C)
- 3-day forecast with (min and max temperature) (°C)
- Probability of rain
- UV index show de number and the meaning for the number
  - 0-2 (weak)
  - 3-5 (moderate)
  - 6-7 (strong)
  - 8+ (very strong)
- Humidity
- Air Pressure (mbar)
- Feelslike (°C)
- Update weather data manually
- Update weather data automatically (when the user enters the app 1 hour or more since the last time the API was called)

# Tech Stack ⚒️

- Flutter (3.47.9)
- Dart (3.13.7)

# Weather Data 💾

- Data provided by [WeatherAPI](https://www.weatherapi.com/)

City Model
```dart
import 'dart:convert';

final class const CityModel({
  required final String name,
  required final String region,
  required final String country,
}) {
  factory fromMap({required Map<String, dynamic> map}) =>
    CityModel(
      name: map["name"] as String, 
      region: map["region"] as String, 
      country: map["country"] as String,
    );

  static List<CityModel> fromJson({required String source}) {
    final decoded = (jsonDecode(source) as List).cast<Map<String, dynamic>>();
    final cityList = decoded.map((map) => CityModel.fromMap(map: map)).toList();
    return cityList;
  }
}
```

Current Weather Model
```dart
import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const CurrentWeatherModel({
  required final String name,
  required final double temperature,
  required final double maxTemp,
  required final double minTemp,
  required final int chanceRain,
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
      chanceRain: 0,
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
    final forecast = map["forecast"]["forecastday"][0] as MSD; 
    final day = forecast["day"] as MSD;

    return CurrentWeatherModel(
      name: map["location"]["name"] as String, 
      temperature: current["temp_c"] as double, 
      maxTemp: day["maxtemp_c"] as double, 
      minTemp: day["mintemp_c"] as double, 
      chanceRain: forecast["hour"][0]["chance_of_rain"] as int,
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
```

Hour by Hour Model
```dart
import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const HourByHourModel({
  required final String date,
  required final String hour,
  required final double temperature,
  required final String iconURL,
}) {
  factory fromMap({required MSD map, required String date}) {
    final hour = (map["time"] as String);
    final justHour = hour.substring(hour.length-5);

    return HourByHourModel(
      date: date, 
      hour: justHour, 
      temperature: map["temp_c"] as double, 
      iconURL: map["condition"]["icon"] as String,
    );
  }

  static List<HourByHourModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecast = decoded["forecast"]["forecastday"][0] as MSD;
    final date = forecast["date"] as String;
    final hour = (forecast["hour"] as List).cast<MSD>();

    return hour.map((e) => 
      HourByHourModel.fromMap(map: e, date: date)).toList();
  }
}
```

Forecast Model
```dart
import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const ForecastModel({
  required final String date,
  required final double maxTemp,
  required final double minTemp,
  required final String maxTempIconURL,
  required final String minTempIconURL,
}) {
  static MSD _getIcon({required MSD map, required double value}) {
    final hour = (map["hour"] as List).cast<MSD>();
    return hour.where(
      (e) => (e["temp_c"] as double) == value
    ).first;
  }

  factory fromMap({required MSD map}) {
    final maxTempIconURL = _getIcon(map: map, value: (map["day"]["maxtemp_c"] as double));
    final minTempIconURL = _getIcon(map: map, value: (map["day"]["mintemp_c"] as double));

    return ForecastModel(
      date: map["date"] as String, 
      maxTemp: map["day"]["maxtemp_c"] as double, 
      minTemp: map["day"]["mintemp_c"] as double, 
      maxTempIconURL: maxTempIconURL["condition"]["icon"] as String, 
      minTempIconURL: minTempIconURL["condition"]["icon"] as String,
    );
  }

  static List<ForecastModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecastList = (decoded["forecast"]["forecastday"] as List).cast<MSD>();

    return forecastList.map((e) => ForecastModel.fromMap(map: e)).toList();
  }
}
```

# App Structure 📁

```
├───lib
│   ├───core
│   │   ├───constants
│   │   ├───di
│   │   ├───exports
│   │   ├───routes
│   │   ├───themes
│   │   └───utils
│   ├───data
│   │   ├───local_database
│   │   ├───models
│   │   └───repositories
│   └───ui
│       ├───controllers
│       ├───screens
│       └───widgets
│           ├───home_widgets
│           └───search_bar
```

- **core** - general elements of the application
  - **constants** - immutable values such as API domain
  - **di** - simple dependency injection 
  - **exports** - concentrate every file the screens need to work
  - **routes** - logic for routing
  - **themes** - themes used in the app such as colors, dimensions, ThemeData
  - **utils** - useful piece of code to be used across de application
- **data** - data source of the app
  - **local_database** - implementation of a local data persistence using [*sqflite*](https://pub.dev/packages/sqflite)
  - **models** - data models showed in **_Weather Data_** section
  - **repositories** - boundaries between the application and the external data source "WeatherAPI"
- **ui** - presentation layer of the application
  - **controllers** - responsible to create a "bridge" between UI and repositories
  - **screens** - the final result where everything is concentrated together and prepared to be seen by the user
  - **widgets** - reusable components of the app