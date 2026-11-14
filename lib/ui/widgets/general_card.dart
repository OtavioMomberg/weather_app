import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_themes.dart';

class const GeneralCard({
  final BorderRadius borderRadius = AppThemes.stdBorderRadius,
  final EdgeInsets padding = AppThemes.midPadding,
  final double? height,
  final double? width,
  final Color? color,
  final Color? borderColor,
  final VoidCallback? onTap,
  final Widget? child, 
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: () => onTap != null ? onTap!() : () {},
        borderRadius: borderRadius,
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: borderColor == null ? null : .all(color: borderColor!),
          ),
          child: child,
        ),
      ),
    );
  }
}