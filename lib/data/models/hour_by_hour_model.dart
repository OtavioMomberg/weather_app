import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const HourByHourModel({
  required final DateTime date,
  required final DateTime hour,
  required final double temperature,
  required final String iconURL,
}) {
  factory fromMap({required MSD map, required DateTime date}) {
    return HourByHourModel(
      date: date, 
      hour: map["time"] as DateTime, 
      temperature: map["temp_c"] as double, 
      iconURL: map["condition"]["text"] as String,
    );
  }

  static List<HourByHourModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecast = decoded["forecast"]["forecastday"][0] as MSD;
    final date = forecast["date"] as DateTime;
    final hour = (forecast["hour"] as List).cast<MSD>();

    return hour.map((e) => 
      HourByHourModel.fromMap(map: e, date: date)).toList();
  }
}