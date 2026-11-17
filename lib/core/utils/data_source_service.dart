import 'package:http/http.dart' as http;
import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/data/local_database/database.dart';
import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';
import 'package:weather_app/ui/controllers/weather_controller.dart';

typedef Controller = AppDi<WeatherController>;
typedef Hour = List<HourByHourModel>;
typedef Forecast = List<ForecastModel>;
typedef Current = CurrentWeatherModel;

const defaultCity = "São Paulo";
const defaultTestURL = "https://www.google.com";
const timeout = 2;

final class DataSourceService._() {
  static final _instance = DataSourceService._();
  factory instance() => _instance;

  bool _dataChanged = false;
  bool get getDataChanged => _dataChanged;

  final _db = LocalDatabase.instance();

  final _weatherController = Controller().getController(
    controllerType: .weather,
  );

  final Hour _hourByHour = [];
  Hour get getHourByHour => _hourByHour;

  final Forecast _forecast = [];
  Forecast get getForecast => _forecast;

  Current _current = .empty();
  Current get getCurrent => _current;

  Future<void> apiData() async {
    if (!await _checkInternet()) { return; }
    await _weatherController.onGetWeather(
      city: CityStorage.instance().cityName ?? defaultCity,
    );

    if (_weatherController.getErrorWeather == null) {
      _current = _weatherController.getWether.currentWeatherModel;
      _hourByHour..clear()..addAll(
        _weatherController.getWether.hourByHourModel);
      _forecast..clear()..addAll(
        _weatherController.getWether.forecastModel);
      _dataChanged = true;
      await localData();
    }
  }

  Future<void> localData() async {
    final response = await _db.selectCurrent();
    if (response == null) {
      await add();
      return;
    }
    if (_dataChanged) {
      await update();
      return;
    } 
    _current = (await _db.selectCurrent())!;
    _hourByHour..clear()..addAll(await _db.selectHour());
    _forecast..clear()..addAll(await _db.selectForecast());
  }

  Future<void> add() async {
    await _db.insertCurrent(
      model: _weatherController.getWether.currentWeatherModel, 
      lastApiCall: DateTime.now().toIso8601String(),
    );
    for (var item in _weatherController.getWether.hourByHourModel) {
      await _db.insertHour(model: item);
    }
    for (var item in _weatherController.getWether.forecastModel) {
      await _db.insertForecast(model: item);
    }
  }

  Future<void> update() async {
    await _db.updateCurrent(
      model: _weatherController.getWether.currentWeatherModel, 
      lastApiCall: DateTime.now().toIso8601String(),
    );
    for (int i=0; i<_weatherController.getWether.hourByHourModel.length; i++) {
      await _db.updateHour(
        model: _weatherController.getWether.hourByHourModel[i], 
        id: i+1
      );
    }
    for (int i=0; i<_weatherController.getWether.forecastModel.length; i++) {
      await _db.updateForecast(
        model: _weatherController.getWether.forecastModel[i], 
        id: i+1,
      );
    }
    _dataChanged = false;
  }

  Future<void> updateWeatherData() async {
    if (!await _checkInternet()) { return; }
    final lastCall = await _db.selectLastApiCall();
    if (lastCall != null) {
      final toDateTime = DateTime.tryParse(lastCall);
      if (toDateTime != null) {
        if (DateTime.now().difference(toDateTime).inHours >= 1) {
          apiData();
          _dataChanged = true;
        }
      }
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final response = await http.get(
        .parse(defaultTestURL),
      ).timeout(const Duration(seconds: timeout));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}