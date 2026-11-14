import 'package:material_ui/material_ui.dart';
import 'package:weather_app/ui/controllers/city_controller.dart';
import 'package:weather_app/core/exports/select_screen_core_exports.dart';
import 'package:weather_app/core/exports/select_screen_ui_exports.dart';

typedef Controller = AppDi<CityController>;

class const SelectCityScreen({
  required final CityStorage cityStorage,
  super.key,
}) extends StatefulWidget {
  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  late final CityController _cityController;
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    _cityController = Controller().
      getController(controllerType: .city);
    searchController = SearchController();
  }

  @override
  void dispose() {
    _cityController.getCityModel.dispose();
    searchController.dispose();
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
            const SizedBox(height: 10),
            Text(
              "Selecione uma Cidade",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            CustomSearchBar(
              cityController: _cityController,
              searchController: searchController,
            ),
            const SizedBox(height: 40),
            Button(
              label: "Confirmar",
              widthFactor: .7,
              borderRadius: AppThemes.searchBarBorderRadius,
              color: Theme.of(context).colorScheme.onPrimary,
              textColor: AppColors.blue.withValues(alpha: .8),
              onTap: _saveCity,
            ),
            const SizedBox(height: 40),
            if (widget.cityStorage.cityName != null) ...[
              Align(
                alignment: .centerLeft,
                child: Text(
                  "Cidade Atual:",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 10),
              GeneralCard(
                height: 100,
                color: AppColors.darkBlue,
                child: Row(
                  spacing: 5,
                  children: <Widget>[
                    const Icon(Icons.location_on),
                    Text(
                      widget.cityStorage.cityName!,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveCity() async {
    if (searchController.text == "") { return; }
    await widget.cityStorage.getCity(newCity: searchController.text);
    if (!mounted) { return; }
    Navigator.popUntil(context, ((route) => route.isFirst));
    Navigator.pushReplacement(
      context,
      AppRoutes.navigate(
        screen: HomeScreen(
          cityStorage: widget.cityStorage,
        ),
      ),
    );
  }
}