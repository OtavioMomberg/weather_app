import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const ForecastModel({
  required final DateTime date,
  required final double maxTemp,
  required final double minTemp,
  required final String maxTempIconURL,
  required final String minTempIconURL,
}) {
  static MSD _getIcon({required MSD map, required double value}) {
    final hour = (map["hour"] as List).cast<MSD>();
    return hour.where(
      (e) => (e["temp_c"] as double) == value
    ).first;
  }

  factory fromMap({required MSD map}) {
    final maxTempIconURL = _getIcon(map: map, value: (map["day"]["maxtemp_c"] as double));
    final minTempIconURL = _getIcon(map: map, value: (map["day"]["mintemp_c"] as double));

    return ForecastModel(
      date: map["date"] as DateTime, 
      maxTemp: map["day"]["maxtemp_c"] as double, 
      minTemp: map["day"]["mintemp_c"] as double, 
      maxTempIconURL: maxTempIconURL["condition"]["text"] as String, 
      minTempIconURL: minTempIconURL["condition"]["text"] as String,
    );
  }

  static List<ForecastModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecastList = (decoded["forecast"]["forecastday"] as List).cast<MSD>();

    return forecastList.map((e) => ForecastModel.fromMap(map: e)).toList();
  }
}