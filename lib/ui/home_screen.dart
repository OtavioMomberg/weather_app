import 'package:material_ui/material_ui.dart';
import 'package:weather_app/ui/widgets/formatted_container.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const HomeScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FormattedContainer(
        useSafeArea: true,
        child: Column(
          spacing: 5,
          children: <Widget>[
            GeneralCard(
              child: Column(
                spacing: 5,
                children: <Widget>[
                  Text("Itapetiniga", style: Theme.of(context).textTheme.headlineMedium,),
                  Text("25°C", style: Theme.of(context).textTheme.displayLarge,),
                ],
              ),
            ),
            Text("24 hours forecast"),
            Text("3-day forecast"),
            Text("General Info (eg. Humidity, Pressure, UV Index...)"),
          ],
        ),
      ),
    );
  }
}