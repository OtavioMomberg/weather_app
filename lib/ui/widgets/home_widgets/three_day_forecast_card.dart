import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const ThreeDayForecastCard({
  required final List<ForecastModel> forecast,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      width: .infinity,
      child: Column(
        children: [
          Align(
            alignment: .centerLeft, 
            child: Text("Previsão para 3 dias"),
          ),
          const SizedBox(height: 10),
          ....generate(forecast.length, (index) {
            return Padding(
              padding: const .only(bottom: 10),
              child: GeneralCard(
                color: AppColors.darkBlue.withValues(alpha: .5),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text("${forecast[index].date} "),
                    _getImage(
                      maxTempIconURL: forecast[index].maxTempIconURL, 
                      minTempIconURL: forecast[index].minTempIconURL
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        GeneralCard(
                          child: Center(
                            child: Text("${forecast[index].minTemp}°"),
                          ),
                        ),
                        GeneralCard(
                          child: Center(
                            child: Text("${forecast[index].maxTemp}°"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

Widget _getImage({
  required String maxTempIconURL, 
  required String minTempIconURL
}) {
  if (DateTime.now().hour >= 12) {
    return Image.network(
      "https:$maxTempIconURL",
      width: 35,
      errorBuilder: (context, _, _) 
        => const Icon(Icons.broken_image),
    );
  }
  return Image.network(
    "https:$minTempIconURL",
    width: 35,
    errorBuilder: (context, _, _) 
      => const Icon(Icons.broken_image),
  );
}