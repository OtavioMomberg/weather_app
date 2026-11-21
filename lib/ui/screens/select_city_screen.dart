import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/exports/select_screen_core_exports.dart';

typedef CController = AppDi<CityController>;

class const SelectCityScreen({super.key}) extends StatefulWidget {
  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final cityStorage = CityStorage.instance();
  late final CityController _cityController;
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    _cityController = CController().getController(controllerType: .city);
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
          children: [
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
            if (cityStorage.cityName != null) ...[
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
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      cityStorage.cityName!,
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
    await cityStorage.getCity(newCity: searchController.text);
    await DataSourceService.instance().apiData();
    if (!mounted) { return; }
    Navigator.popUntil(context, ((route) => route.isFirst));
    Navigator.pushReplacement(
      context,
      AppRoutes.navigate(screen: const HomeScreen()),
    );
  }
}