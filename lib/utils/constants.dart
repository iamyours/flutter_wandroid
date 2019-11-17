import 'package:flutter/services.dart';

class Constants {
  static const bool isDebug = !bool.fromEnvironment("dart.vm.product");
  static const MethodChannel channel = const MethodChannel("event");
}
