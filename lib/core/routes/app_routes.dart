import 'package:material_ui/material_ui.dart';

final class const AppRoutes._() {
  static Route<dynamic> navigate({required Widget screen}) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => screen,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween), 
          child: child,
        );
      },
    );
  }
}