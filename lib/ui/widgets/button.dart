import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_themes.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const Button({
  required final String label,
  final BorderRadius borderRadius = AppThemes.searchBarBorderRadius,
  final double? widthFactor,
  final Color? color,
  final Color? textColor,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: GeneralCard(
        borderRadius: borderRadius,
        color: color,
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
