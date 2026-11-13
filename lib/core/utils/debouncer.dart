import 'dart:async';

final class Debouncer({required final Duration duration}) {
  Timer? _timer;

  void run({required void Function() action}) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() => _timer?.cancel();
}