import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Global {
  String? languageId;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
