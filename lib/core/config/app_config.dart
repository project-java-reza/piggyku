import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  static AppEnvironment? _environment;

  static AppEnvironment get environment {
    return _environment ??= AppEnvironment.development;
  }

  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  static Duration connectTimeout = const Duration(seconds: 120);
  static Duration receiveTimeout = const Duration(seconds: 120);

  // WhatsApp Configuration
  static String get whatsappWebhookUrl => environment.whatsappWebhookUrl;

  static String get whatsappApiBaseUrl => environment.isDev
      ? 'https://webhook.site/your-webhook-url'  // Ganti dengan webhook URL untuk development
      : 'https://api.your-domain.com';

  static String get whatsappToken => environment.isDev
      ? 'YOUR_DEV_WHATSAPP_TOKEN'
      : 'YOUR_PROD_WHATSAPP_TOKEN';

  static String get phoneNumberId => environment.isDev
      ? 'YOUR_DEV_PHONE_NUMBER_ID'
      : 'YOUR_PROD_PHONE_NUMBER_ID';

  AppConfig({super.key, required super.child, required AppEnvironment env}) {
    setEnvironment(env);
  }
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

enum AppEnvironment {
  development(
    /// Using JSONPlaceholder for testing - replace with actual API when available
    url: 'https://jsonplaceholder.typicode.com',
    isDebug: true,
    whatsappWebhookUrl: 'https://webhook.site/your-webhook-url', // Ganti dengan webhook URL untuk development
  ),
  production(
    /// TODO : add production url
    url: 'https://api.finai.com',
    isDebug: false,
    whatsappWebhookUrl: 'https://api.your-domain.com/webhook', // Ganti dengan production webhook URL
  );

  final bool isDebug;
  final String url;
  final String whatsappWebhookUrl;

  const AppEnvironment({
    required this.isDebug,
    required this.url,
    required this.whatsappWebhookUrl,
  });

  bool get isDev => this == AppEnvironment.development;

  bool get isProd => this == AppEnvironment.production;
}

// Mock configuration moved outside the enum
class MockConfig {
  static const bool enabled = true; // Set to true to enable mock mode
  static const String email = 'test@example.com';
  static const String password = 'password123';

  static bool get isEnabled => enabled && AppConfig.environment.isDev;
}
