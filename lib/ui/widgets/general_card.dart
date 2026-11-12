import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/core/themes/app_themes.dart';

class const GeneralCard({
  final BorderRadius borderRadius = AppThemes.stdBorderRadius,
  final EdgeInsets padding = AppThemes.midPadding,
  final VoidCallback? onTap,
  final Widget? child, 
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: .all(color: AppColors.whiteBlueish),
          ),
          child: child,
        ),
      ),
    );
  }
}