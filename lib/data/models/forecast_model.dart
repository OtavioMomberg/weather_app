import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const ForecastModel({
  required final String date,
  required final double maxTemp,
  required final double minTemp,
  required final String maxTempIconURL,
  required final String minTempIconURL,
}) {
  static String _getIcon({required MSD map, required double value}) {
    final hour = (map["hour"] as List).cast<MSD>();
    return hour.where(
      (e) => (e["temp_c"] as double) == value
    ).first["condition"]["icon"] as String;
  }

  factory fromMap({required MSD map}) {
    final maxTempIconURL = _getIcon(map: map, value: (map["day"]["maxtemp_c"] as double));
    final minTempIconURL = _getIcon(map: map, value: (map["day"]["mintemp_c"] as double));
    final date = (map["date"] as String).split("-");

    return ForecastModel(
      date: "${date.last}/${date[1]}", 
      maxTemp: map["day"]["maxtemp_c"] as double, 
      minTemp: map["day"]["mintemp_c"] as double, 
      maxTempIconURL: "https:$maxTempIconURL", 
      minTempIconURL: "https:$minTempIconURL",
    );
  }

  static List<ForecastModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecastList = (decoded["forecast"]["forecastday"] as List).cast<MSD>();

    return forecastList.map((e) => ForecastModel.fromMap(map: e)).toList();
  }
}