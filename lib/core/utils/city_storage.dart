import 'package:shared_preferences/shared_preferences.dart';

final class CityStorage._() {
  static final _instance = CityStorage._();
  factory instance() => _instance;

  static const city = "city";

  late SharedPreferencesWithCache _prefs;

  String? get cityName => _prefs.getString(city);

  Future<void> loadCity() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {city},
      ),
    );
    _prefs.getString(city);
  }

  Future<void> getCity({required String newCity}) async =>
    await _prefs.setString(city, newCity);
}