import 'package:material_ui/material_ui.dart';
import 'package:weather_app/core/themes/app_colors.dart';
import 'package:weather_app/ui/widgets/general_card.dart';

class const ExtraInfoCard({
  required final String title,
  required final String content,
  final String? extra,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneralCard(
      height: 150,
      child: Column(
        children: [
          Align(
            alignment: .centerLeft, 
            child: Text(title),
          ),
          Divider(color: AppColors.darkBlue.withValues(alpha: .5)),
          const SizedBox(height: 20),
          if (extra != null)...[
            Text(
              extra!, 
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: .bold,
              ),
              textAlign: .center,
            ),
          ],
          Text(
            content, 
            style: const TextStyle(fontSize: 25),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}