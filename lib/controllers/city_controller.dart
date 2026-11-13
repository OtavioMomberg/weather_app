import 'package:material_ui/material_ui.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/repositories/city_repository.dart';

typedef City = ValueNotifier<List<CityModel>>;

final class CityController({
  required final CityRepository respository,
}) {
  String? _errorGetCity;
  String? get getErrorCity => _errorGetCity;

  final _cityModel = City([]);
  City get getCityModel => _cityModel;

  Future<void> onGetCity({required String query}) async {
    _errorGetCity = null;
    try {
      final response = await respository.getCity(query: query);

      if (response.isNotEmpty) {
        _cityModel.value = response;
      }
    } catch (error) {
      _errorGetCity = error.toString();
    }
  }
}