import 'package:finai_frontend/app/domain/entities/constant.dart';
import 'package:finai_frontend/app/domain/entities/global.dart';
import 'package:finai_frontend/core/services/injection.dart';
import 'package:finai_frontend/core/util/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'l10n.dart';

final BuildContext? _context =
    getIt<Global>().navigatorKey.currentState?.context;

S get translator {
  final instance = S.maybeOf(_context!);
  assert(instance != null,
      'No instance of Translator present in the widget tree. Did you add Translator.delegate in localizationsDelegates?');
  return instance!;
}

Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates() {
  return [
    const AppLocalizationDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate
  ];
}

loadLang() async {
  var lang = await Prefs.getLanguage;
  switch (lang) {
    case 'en':
      Get.updateLocale(Constant.localeEn);
      break;
    case 'id':
      Get.updateLocale(Constant.localeId);
      break;
  }
}
