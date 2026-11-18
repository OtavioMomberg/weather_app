import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const TemperatureCard({
  required final String name,
  required final String temperature,
  required final String condition,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      width: .infinity,
      color: AppColors.darkBlue,
      child: Column(
        spacing: 10,
        children: <Widget>[
          Text(
            name, 
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "$temperature°",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(condition),
        ],
      ),
    );
  }
}
