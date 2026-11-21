import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/data/local_database/database.dart';
import 'package:weather_app/data/models/current_weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';
import 'package:weather_app/ui/controllers/weather_controller.dart';

typedef WController = AppDi<WeatherController>;
typedef Hour = List<HourByHourModel>;
typedef Forecast = List<ForecastModel>;
typedef Current = CurrentWeatherModel;

const defaultCity = "São Paulo";

final class DataSourceService._() {
  static final _instance = DataSourceService._();
  factory instance() => _instance;

  bool _dataChanged = false;
  bool get getDataChanged => _dataChanged;

  bool _apiUpdated = false;
  bool get getApiUpdated => _apiUpdated;

  final _db = LocalDatabase.instance();

  final _weatherController = WController().getController(
    controllerType: .weather,
  );

  final Hour _hourByHour = [];
  Hour get getHourByHour => _hourByHour;

  final Forecast _forecast = [];
  Forecast get getForecast => _forecast;

  Current _current = .empty();
  Current get getCurrent => _current;

  Future<void> apiData() async {
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
      _apiUpdated = true;
      await localData();
      _dataChanged = true;
      return;
    }
    _apiUpdated = false;
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
    _current = response;
    _hourByHour..clear()..addAll(await _db.selectHour());
    _forecast..clear()..addAll(await _db.selectForecast());
  }

  Future<void> add() async {
    await _db.insert(
      cModel: _weatherController.getWether.currentWeatherModel, 
      hModel: _weatherController.getWether.hourByHourModel, 
      fModel: _weatherController.getWether.forecastModel, 
      lastApiCall: DateTime.now().toIso8601String(),
    );
  }

  Future<void> update() async {
    await _db.update(
      cModel: _weatherController.getWether.currentWeatherModel, 
      lastApiCall: DateTime.now().toIso8601String(), 
      hModel: _weatherController.getWether.hourByHourModel, 
      fModel: _weatherController.getWether.forecastModel, 
    );
    _dataChanged = false;
  }

  Future<void> updateWeatherData() async {
    final lastCall = await _db.selectLastApiCall();
    if (lastCall != null) {
      final toDateTime = DateTime.tryParse(lastCall);
      if (toDateTime != null) {
        if (DateTime.now().difference(toDateTime).inHours >= 1) {
          await apiData();
        }
      }
    }
  }
}