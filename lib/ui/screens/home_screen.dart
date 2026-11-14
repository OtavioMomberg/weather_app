import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/routes/app_routes.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/ui/screens/select_city_screen.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const HomeScreen({
  required final CityStorage cityStorage,
  super.key,
}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.update),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AppRoutes.navigate(
                  screen: SelectCityScreen(
                    cityStorage: widget.cityStorage,
                  ),
                ),
              );
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: FormattedContainer(
        useSafeArea: true,
        child: Column(
          spacing: 5,
          children: <Widget>[
            GeneralCard(
              child: Column(
                spacing: 5,
                children: <Widget>[
                  Text(
                    widget.cityStorage.cityName!, 
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "25°C", 
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            Text("24 hours forecast"),
            Text("3-day forecast"),
            Text("General Info (eg. Humidity, Pressure, UV Index...)"),
          ],
        ),
      ),
    );
  }
}