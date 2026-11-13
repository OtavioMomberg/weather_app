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