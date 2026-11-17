import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/routes/app_routes.dart';
import 'package:weather_app/core/themes/app_colors.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await weather.updateWeatherData();
      if(weather.getDataChanged) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await weather.apiData();
              setState(() {});
            },
            icon: Icon(Icons.update),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AppRoutes.navigate(screen: const SelectCityScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
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
                color: AppColors.darkBlue,
                child: Column(
                  spacing: 10,
                  children: <Widget>[
                    Text(
                      weather.getCurrent.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "${weather.getCurrent.temperature}°",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(weather.getCurrent.condition),
                  ],
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: GeneralCard(
                      color: AppColors.darkBlue.withValues(alpha: .5),
                      child: Text(
                        "Mínima: ${weather.getCurrent.minTemp}°",
                      ),
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      color: AppColors.darkBlue.withValues(alpha: .5),
                      child: Text(
                        "Máxima: ${weather.getCurrent.maxTemp}°",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GeneralCard(
                child: Column(
                  spacing: 10,
                  children: [
                    Align(
                      alignment: .centerLeft,
                      child: Text("Previsão de 24 horas"),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: .horizontal,
                        itemCount: weather.getHourByHour.length,
                        itemExtent: 100,
                        itemBuilder: (context, index) {
                          return GeneralCard(
                            padding: .symmetric(vertical: 14),
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Text("${weather.getHourByHour[index].temperature}°"),
                                Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                                const SizedBox(height: 10),
                                Image.network(
                                  "https:${weather.getHourByHour[index].iconURL}",
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text("${weather.getHourByHour[index].hour} "),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              GeneralCard(
                width: .infinity,
                child: Column(
                  children: [
                    Align(
                      alignment: .centerLeft,
                      child: Text("Previsão para 3 dias"),
                    ),
                    const SizedBox(height: 10,),
                    ....generate(weather.getForecast.length, (index) {
                      return Padding(
                        padding: const .only(bottom: 10),
                        child: GeneralCard(
                          color: AppColors.darkBlue.withValues(alpha: .5),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text("${weather.getForecast[index].date} "),
                              if (DateTime.now().hour >= 12)...[
                                Image.network(
                                  "https:${weather.getForecast[index].maxTempIconURL}",
                                  width: 35,
                                ),
                              ] else...[
                                Image.network(
                                  "https:${weather.getForecast[index].minTempIconURL}",
                                  width: 35,
                                ),
                              ],
                              Row(
                                spacing: 10,
                                children: [
                                  GeneralCard(
                                    child: Center(
                                      child: Text("${weather.getForecast[index].minTemp}°"),
                                    )
                                  ),
                                  GeneralCard(
                                    child: Center(
                                      child: Text("${weather.getForecast[index].maxTemp}°")
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                )
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: GeneralCard(
                      height: 150,
                      child: Column(
                        children: [
                          Align(
                            alignment: .centerLeft,
                            child: Text("UV Index"),
                          ),
                          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                          const SizedBox(height: 20),
                          Text(
                            "${weather.getCurrent.uvIndex}",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      height: 150,
                      child: Column(
                        children: [
                          Align(
                            alignment: .centerLeft,
                            child: Text("Umidade"),
                          ),
                          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                          const SizedBox(height: 20),
                          Text(
                            "${weather.getCurrent.humidity}%",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: GeneralCard(
                      height: 150,
                      child: Column(
                        children: [
                          Align(
                            alignment: .centerLeft,
                            child: Text("Pressão (mbar)"),
                          ),
                          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                          const SizedBox(height: 20),
                          Text(
                            "${weather.getCurrent.pressureMB}",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      height: 150,
                      child: Column(
                        children: [
                          Align(
                            alignment: .centerLeft,
                            child: Text("Sensação Termíca"),
                          ),
                          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
                          const SizedBox(height: 20),
                          Text(
                            "${weather.getCurrent.feelslike}°",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
