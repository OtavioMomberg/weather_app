import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/core/themes/app_themes.dart';
import 'package:weather_app/core/utils/app_gate.dart';
import 'package:weather_app/core/utils/city_storage.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString("assets/fonts/OFL.txt");
    yield LicenseEntryWithLineBreaks(["Google Fonts - ShareTech"], license);
  });

  await SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);
  
  await CityStorage.instance().loadCity();

  runApp(const Weather());
}

class const Weather({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      debugShowCheckedModeBanner: false,
      theme: AppThemes.themeData,
      home: AppGate.getScreen(),
    );
  }
}