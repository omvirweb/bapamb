import 'dart:async';
import 'package:rxdart/rxdart.dart';

class DataStream {
  final _controller = BehaviorSubject<String>();

  Stream<String> get stream => _controller.stream;

  void start() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _controller.sink.add("Data ${DateTime.now()}");
    });
  }

  void dispose() {
    _controller.close();
  }
}
