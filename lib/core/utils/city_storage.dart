import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/utils/data_source_service.dart';

const city = "city";

final class CityStorage._() {
  static final _instance = CityStorage._();
  factory instance() => _instance;

  late SharedPreferencesWithCache _prefs;

  String? get cityName => _prefs.getString(city);

  Future<void> loadCity() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {city},
      ),
    );
    _prefs.getString(city);

    if (cityName != null) {
      await DataSourceService.instance().localData();
    }
  }

  Future<void> getCity({required String newCity}) async =>
    await _prefs.setString(city, newCity);
}
