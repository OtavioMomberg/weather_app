import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/exports/home_screen_core_exports.dart';

class const HomeScreen({super.key}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SnackbarMixin {
  final weather = DataSourceService.instance();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await weather.updateWeatherData();
      if (weather.getDataChanged) {
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
              if (!context.mounted) { return; }
              snackbar(
                context: context, 
                label: weather.getApiUpdated ? "Dados Atualizados" : "Erro ao Atualizar", 
                labelColor: AppColors.darkBlue, 
                backgroundColor: AppColors.whiteBlueish,
                margin: .symmetric(horizontal: 10, vertical: 15)
              );
            },
            icon: const Icon(Icons.update),
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
              TemperatureCard(
                name: weather.getCurrent.name,
                temperature: weather.getCurrent.temperature.toString(),
                condition: weather.getCurrent.condition,
              ),
              Row(
                spacing: 5,
                children: <Widget>[
                  Expanded(
                    child: GeneralCard(
                      color: AppColors.darkBlue.withValues(alpha: .5),
                      child: Text("Mínima: ${weather.getCurrent.minTemp}°"),
                    ),
                  ),
                  Expanded(
                    child: GeneralCard(
                      color: AppColors.darkBlue.withValues(alpha: .5),
                      child: Text("Máxima: ${weather.getCurrent.maxTemp}°"),
                    ),
                  ),
                ],
              ),
              GeneralCard(
                width: .infinity,
                color: AppColors.darkBlue.withValues(alpha: .5),
                child: Text(
                  "Chance de Chuva: ${weather.getCurrent.chanceRain}%",
                ),
              ),
              const SizedBox(height: 5),
              OneDayForecastCard(hourByHour: weather.getHourByHour),
              const SizedBox(height: 5),
              ThreeDayForecastCard(forecast: weather.getForecast),
              const SizedBox(height: 5),
              Row(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: _ExtraInfoCard(
                      title: "UV Index", 
                      content: "${weather.getCurrent.uvIndex}",
                      extra: "${_getUVIndex(uv: weather.getCurrent.uvIndex)} ",
                    ),
                  ),
                  Expanded(
                    child: _ExtraInfoCard(
                      title: "Umidade", 
                      content: "${weather.getCurrent.humidity}%",
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: _ExtraInfoCard(
                      title: "Pressão (mbar)", 
                      content: "${weather.getCurrent.pressureMB}",
                    ),
                  ),
                  Expanded(
                    child: _ExtraInfoCard(
                      title: "Sensação Termíca", 
                      content: "${weather.getCurrent.feelslike}°",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Align(
                alignment: .center,
                child: const Text("Dados fornecidos da WeatherAPI"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUVIndex({required double uv}) {
    if (uv <= 2) { return "Baixo"; }
    if (uv <= 5) { return "Moderado"; }
    if (uv <= 7) { return "Alto"; }
    return "Muito Alto";
  }
}

class const _ExtraInfoCard({
  required final String title,
  required final String content,
  final String? extra,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      height: 150,
      child: Column(
        children: <Widget>[
          Align(
            alignment: .centerLeft, 
            child: Text(title),
          ),
          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
          const SizedBox(height: 20),
          if (extra != null)...[
            Text(
              extra!, 
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: .bold,
              ),
              textAlign: .center,
            ),
          ],
          Text(
            content, 
            style: const TextStyle(fontSize: 25),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}