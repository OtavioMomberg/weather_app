import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/routes/app_routes.dart';
import 'package:weather_app/core/utils/data_source_service.dart';
import 'package:weather_app/ui/screens/select_city_screen.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const HomeScreen({super.key}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final weather = DataSourceService.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await weather.run();
              setState(() {});
            }, 
            icon: Icon(Icons.update),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AppRoutes.navigate(
                  screen: const SelectCityScreen(),
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
                      weather.weatherController.getCurrent.name, 
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "${weather.weatherController.getCurrent.temperature}°", 
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(weather.weatherController.getCurrent.condition)
                  ],
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: GeneralCard(
                      child: Text(
                        "Mínima: ${weather.weatherController.getCurrent.minTemp}°"
                      ),
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      child: Text(
                        "Máxima: ${weather.weatherController.getCurrent.maxTemp}°"
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
                  itemCount: weather.weatherController.getHourByHour.length,
                  separatorBuilder: (_, _) { return const SizedBox(width: 10); },
                  itemBuilder: (context, index) {
                    return GeneralCard(
                      child: Text(
                        "${weather.weatherController.getHourByHour[index].date} - "
                        "${weather.weatherController.getHourByHour[index].hour}\n"
                        "${weather.weatherController.getHourByHour[index].temperature}"
                      ),
                    );
                  }, 
                ),
              ),
              Text("3-day forecast"),
              ....generate(weather.weatherController.getForecast.length, (index) {
                return Text(
                  "${weather.weatherController.getForecast[index].date}\n"
                  "${weather.weatherController.getForecast[index].minTemp} - "
                  "${weather.weatherController.getForecast[index].maxTemp}"
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