import 'package:material_ui/material_ui.dart';
import 'package:weather_app/controllers/city_controller.dart';

class const SuggestionOptions({
  required final CityController cityController,
  required final SearchController controller,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cityController.getCityModel,
      builder: (context, cities, _) {
        return Column(
          mainAxisSize: .min,
          children: <Widget>[
            ...cities.map((city) {
              return ListTile(
                onTap: () {
                  controller.closeView(city.name);
                  cityController..addCityToHistory(city: city)
                    ..addHistoryToSuggestions();
                },
                title: Text(city.name),
                subtitle: Text(
                  "${city.region}, ${city.country}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                trailing: IconButton(
                  onPressed: () {
                    cityController.getCityHistory.
                      removeWhere((e) => e.name == city.name);
                    cityController.addHistoryToSuggestions();
                  },
                  icon: const Icon(Icons.close),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}