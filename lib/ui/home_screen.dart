import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_themes.dart';

class const HomeScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: .infinity,
        decoration: const BoxDecoration(
          gradient: AppThemes.gradient
        ),
      ),
    );
  }
}