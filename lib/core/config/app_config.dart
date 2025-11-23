import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  static late AppEnvironment environment;

  static Duration connectTimeout = const Duration(seconds: 120);
  static Duration receiveTimeout = const Duration(seconds: 120);

  AppConfig({super.key, required super.child, required AppEnvironment env}) {
    environment = env;
  }
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

enum AppEnvironment {
  development(
    /// TODO : add development url
    url: '',
    isDebug: true,
  ),
  production(
    /// TODO : add production url
    url: '',
    isDebug: false,
  );

  final bool isDebug;
  final String url;

  const AppEnvironment({
    required this.isDebug,
    required this.url,
  });

  bool get isDev => this == AppEnvironment.development;

  bool get isProd => this == AppEnvironment.production;
}
