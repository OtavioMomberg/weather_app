import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/di/app_di.dart';
import 'package:weather_app/controllers/city_controller.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/core/themes/app_themes.dart';
import 'package:weather_app/core/utils/city_storage.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';
import 'package:weather_app/ui/widgets/general_card.dart';
import 'package:weather_app/ui/widgets/search_bar/custom_search_bar.dart';

typedef Controller = AppDi<CityController>;

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
    _cityController = Controller().getController(controllerType: .city);
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
            Material(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: AppThemes.searchBarBorderRadius,
              child: InkWell(
                onTap: () {},
                borderRadius: AppThemes.searchBarBorderRadius,
                child: Container(
                  height: 60,
                  width: .infinity,
                  padding: AppThemes.stdPadding,
                  decoration: BoxDecoration(
                    borderRadius: AppThemes.searchBarBorderRadius,
                    border: .all(color: AppColors.whiteBlueish), 
                  ),
                  child: Center(
                    child: Text(
                      "Confirmar", 
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (cityStorage.cityName != null)...[
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
                child: Row(
                  spacing: 5,
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text(
                      "Itapetininga", 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                )
              )
            ]
          ],
        ),
      ),
    );
  }
}