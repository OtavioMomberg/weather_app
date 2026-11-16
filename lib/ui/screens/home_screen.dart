import 'package:http/http.dart';
import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/core/routes/app_routes.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/data/repositories/weather_implementation.dart';
import 'package:weather_app/ui/controllers/weather_controller.dart';
import 'package:weather_app/ui/screens/select_city_screen.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

typedef Controller = AppDi<WeatherController>;

class const HomeScreen({
  required final CityStorage cityStorage,
  super.key,
}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WeatherController _weatherController;
  
  @override
  void initState() {
    super.initState();
    _weatherController = WeatherController(
      repository: WeatherImplementation(
        client: Client(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _weatherController.onGetWeather(
        city: widget.cityStorage.cityName!
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _weatherController.onGetWeather(
                city: widget.cityStorage.cityName!
              );
              setState(() {});
            }, 
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
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            children: <Widget>[
              GeneralCard(
                width: .infinity,
                child: Column(
                  spacing: 10,
                  children: <Widget>[
                    Text(
                      _weatherController.getCurrent.name, 
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "${_weatherController.getCurrent.temperature}°", 
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(_weatherController.getCurrent.condition)
                  ],
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: GeneralCard(
                      child: Text(
                        "Mínima: ${_weatherController.getCurrent.minTemp}°"
                      ),
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      child: Text(
                        "Máxima: ${_weatherController.getCurrent.maxTemp}°"
                      ),
                    ),
                  )
                ],
              ),
              Text("24 hours forecast"),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  itemCount: _weatherController.getHourByHour.length,
                  separatorBuilder: (_, _) { return const SizedBox(width: 10); },
                  itemBuilder: (context, index) {
                    return GeneralCard(
                      child: Text(
                        "${_weatherController.getHourByHour[index].date} - "
                        "${_weatherController.getHourByHour[index].hour}\n"
                        "${_weatherController.getHourByHour[index].temperature}"
                      ),
                    );
                  }, 
                ),
              ),
              Text("3-day forecast"),
              ....generate(_weatherController.getForecast.length, (index) {
                return Text(
                  "${_weatherController.getForecast[index].date}\n"
                  "${_weatherController.getForecast[index].minTemp} - "
                  "${_weatherController.getForecast[index].maxTemp}"
                );
              }),
          
              Text("General Info (eg. Humidity, Pressure, UV Index...)"),
            ],
          ),
        ),
      ),
    );
  }
}