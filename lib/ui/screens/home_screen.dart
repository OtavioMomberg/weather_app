import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/exports/home_screen_core_exports.dart';
import 'package:weather_app/core/themes/app_themes.dart';


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
            onPressed: _refreshData,
            icon: const Icon(Icons.update),
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
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FormattedContainer(
        useSafeArea: true,
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            children: [
              TemperatureCard(
                name: weather.getCurrent.name,
                temperature: weather.getCurrent.temperature.toString(),
                condition: weather.getCurrent.condition,
              ),
              Row(
                spacing: 5,
                children: [
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
                children: [
                  Expanded(
                    child: ExtraInfoCard(
                      title: "UV Index", 
                      content: "${weather.getCurrent.uvIndex}",
                      extra: _getUVIndex(uv: weather.getCurrent.uvIndex),
                    ),
                  ),
                  Expanded(
                    child: ExtraInfoCard(
                      title: "Umidade", 
                      content: "${weather.getCurrent.humidity}%",
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ExtraInfoCard(
                      title: "Pressão (mbar)", 
                      content: "${weather.getCurrent.pressureMB}",
                    ),
                  ),
                  Expanded(
                    child: ExtraInfoCard(
                      title: "Sensação Termíca", 
                      content: "${weather.getCurrent.feelslike}°",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Align(
                alignment: .center,
                child: const Text("Dados fornecidos pela WeatherAPI"),
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

  Future<void> _refreshData() async {
    await weather.apiData();
    setState(() {});
    if (!mounted) { return; }
    snackbar(
      context: context, 
      label: weather.getApiUpdated 
        ? "Dados Atualizados" : "Erro ao Atualizar", 
      labelColor: AppColors.darkBlue, 
      backgroundColor: AppColors.whiteBlueish,
      padding: AppThemes.snackBarPadding,
      margin: AppThemes.snackBarPadding,
    );
  }
}