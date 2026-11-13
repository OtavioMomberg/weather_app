import 'package:material_ui/material_ui.dart';
import 'package:weather_app/controllers/city_controller.dart';
import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/core/themes/app_themes.dart';
import 'package:weather_app/core/utils/debouncer.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';

class const SelectCityScreen({super.key}) extends StatefulWidget {
  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  late final Debouncer _debouncer;
  final _cityController = AppDi<CityController>().
    getController(controllerType: .city);
  final searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _cityController.getCityModel.dispose();
    searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FormattedContainer(
        useSafeArea: true,
        child: Column(
          children: <Widget>[
            Text(
              "Selecione uma Cidade",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            SearchAnchor.bar(
              searchController: searchController,
              isFullScreen: false,
              shrinkWrap: true,
              barHintText: "Pesquisar cidade...",
              barElevation: WidgetStatePropertyAll(0),
              viewElevation: 0,
              onChanged: _onSearchChanged,
              viewShape: AppThemes.searchBorder,
              barShape: const WidgetStatePropertyAll(
                AppThemes.searchBorder,
              ),
              viewTrailing: [
                IconButton(
                  onPressed: () {
                    searchController.clear();
                    _cityController.getCityModel.value = [];
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
              suggestionsBuilder: (context, controller) {
                return [
                  ValueListenableBuilder(
                    valueListenable: _cityController.getCityModel,
                    builder: (context, cities, _) {
                      return Column(
                        mainAxisSize: .min,
                        children: cities.map((city) {
                          return ListTile(
                            onTap: () {
                              controller.closeView(city.name);
                              _cityController.getCityModel.value = [city];
                            },
                            title: Text(city.name),
                            subtitle: Text(
                              "${city.region}, ${city.country}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                final itens = _cityController.getCityModel.value;
                                itens.removeWhere((e) => e.name == city.name);
                                _cityController.getCityModel.value = itens
                                  .map((e) => e).toList();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    _debouncer.run(
      action: () async {
        if (query.isEmpty) {
          _cityController.getCityModel.value = [];
        }
        await _cityController.onGetCity(query: query);
      },
    );
  }
}