import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/data/models/hour_by_hour_model.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const OneDayForecastCard({
  required final List<HourByHourModel> hourByHour,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      child: Column(
        spacing: 10,
        children: <Widget>[
          Align(
            alignment: .centerLeft, 
            child: Text("Previsão de 24 horas"),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: hourByHour.length,
              itemExtent: 100,
              itemBuilder: (context, index) {
                return GeneralCard(
                  padding: .symmetric(vertical: 14),
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      Text("${hourByHour[index].temperature}°"),
                      Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                      const SizedBox(height: 10),
                      Image.network(
                        "https:${hourByHour[index].iconURL}",
                        height: 50,
                        errorBuilder: (context, _, _) =>
                          const Icon(Icons.broken_image),
                      ),
                      const SizedBox(height: 5),
                      Text(hourByHour[index].hour),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}