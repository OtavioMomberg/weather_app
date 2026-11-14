import 'package:material_ui/material_ui.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/repositories/city_repository.dart';

typedef City = ValueNotifier<List<CityModel>>;
const historySize = 4;

final class CityController({
  required final CityRepository respository,
}) {
  String? _errorGetCity;
  String? get getErrorCity => _errorGetCity;

  final _cityModel = City([]);
  City get getCityModel => _cityModel;

  final _cityHistory = <CityModel>[];
  List<CityModel> get getCityHistory => _cityHistory;

  void addCityToHistory({required CityModel city}) {
    if (_cityHistory.length == historySize) {
      _cityHistory.removeAt(0);
    }
    _cityHistory.add(city);
  }

  void addHistoryToSuggestions() {
    _cityModel.value = _cityHistory.map((e) => e).toList();
    _cityModel.value = _cityModel.value.reversed.toList();
  }

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