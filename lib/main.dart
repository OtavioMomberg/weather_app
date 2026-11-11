import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/core/themes/app_themes.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/ui/home_screen.dart';

void main() async {
  //await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    .portraitUp, .portraitDown]);

  runApp(const Weather());
}

class const Weather({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      debugShowCheckedModeBanner: false,
      theme: AppThemes.themeData,
      home: const HomeScreen()
    );
  }
}