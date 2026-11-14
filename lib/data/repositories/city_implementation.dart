import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/data/models/city_model.dart';
import 'package:weather_app/data/repositories/city_repository.dart';

final class CityImplementation({
  required final Client _client,
}) implements CityRepository {
  @override
  Future<List<CityModel>> getCity({required String query}) async {
    final domain = searchURL
      .replaceFirst("https://", "")
      .replaceFirst("/v1/search.json", "");
    final path = searchURL.replaceFirst("https://api.weatherapi.com", "");
    final q = {"key": dotenv.get("API_KEY"), "q": query};

    final url = Uri.https(domain, path, q);
    final headers = {
      "Content-Type": "application/json",
      "X-Android-Package": dotenv.get("PACKAGE_ID"),
    };

    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      return CityModel.fromJson(source: response.body);
    }
    throw Exception(response.body);
  }
}
