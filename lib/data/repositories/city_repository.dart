import 'package:weather_app/data/models/city_model.dart';

abstract interface class CityRepository {
  Future<List<CityModel>> getCity({required String query});
}