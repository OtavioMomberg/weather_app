import 'package:material_ui/material_ui.dart';
import 'package:weather_app/controllers/city_controller.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/core/themes/app_themes.dart';
import 'package:weather_app/core/utils/debouncer.dart';
import 'package:weather_app/ui/widgets/search_bar/suggestion_options.dart';

class const CustomSearchBar({
  required final CityController cityController,
  required final SearchController searchController,
  super.key,
}) extends StatefulWidget {
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: widget.searchController,
      barHintText: "Pesquisar cidade...",
      textCapitalization: .sentences,
      //isFullScreen: false,
      shrinkWrap: true,
      viewBackgroundColor: AppColors.blue,
      barElevation: WidgetStatePropertyAll(0),
      viewElevation: 0,
      barShape: const WidgetStatePropertyAll(AppThemes.searchBorder),
      viewShape: AppThemes.searchBorder,
      onChanged: _onSearchChanged,
      viewTrailing: [
        IconButton(
          onPressed: () {
            widget.searchController.clear();
            widget.cityController.getCityModel.value = [];
          },
          icon: const Icon(Icons.close),
        ),
      ],
      suggestionsBuilder: (context, controller) =>
        [
          SuggestionOptions(
            cityController: widget.cityController, 
            controller: controller,
          ),
        ]
    );
  }

  void _onSearchChanged(String query) {
    _debouncer.run(
      action: () async {
        if (query.isEmpty) {
          widget.cityController.getCityModel.value = [];
        }
        await widget.cityController.onGetCity(query: query);
      },
    );
  }
}