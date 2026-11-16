import 'dart:convert';

typedef MSD = Map<String, dynamic>;

final class const HourByHourModel({
  required final String date,
  required final String hour,
  required final double temperature,
  required final String iconURL,
}) {
  factory fromMap({required MSD map, required String date}) {
    final hour = (map["time"] as String);
    final justHour = hour.substring(hour.length-5);

    return HourByHourModel(
      date: date, 
      hour: justHour, 
      temperature: map["temp_c"] as double, 
      iconURL: map["condition"]["text"] as String,
    );
  }

  static List<HourByHourModel> fromJson({required String source}) {
    final decoded = jsonDecode(source) as MSD;
    final forecast = decoded["forecast"]["forecastday"][0] as MSD;
    final date = forecast["date"] as String;
    final hour = (forecast["hour"] as List).cast<MSD>();

    return hour.map((e) => 
      HourByHourModel.fromMap(map: e, date: date)).toList();
  }
}