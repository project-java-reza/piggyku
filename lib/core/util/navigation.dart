import 'package:built_collection/built_collection.dart';
import 'package:finai_frontend/app/domain/entities/global.dart';
import 'package:finai_frontend/core/services/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

Future<dynamic> navigateTo(Widget page, {bool preventDuplicates = true}) async {
  return await Get.to(
    () => page,
    routeName: page.runtimeType.toString(),
    preventDuplicates: preventDuplicates,
  );
}

dynamic navigateOff(Widget page) =>
    Get.off(() => page, routeName: page.runtimeType.toString());
dynamic navigateOffAll(Widget page) =>
    Get.offAll(() => page, routeName: page.runtimeType.toString());
navigateBack() => Get.back();
navigatePop([dynamic result]) {
  final BuildContext? context =
      getIt<Global>().navigatorKey.currentState?.context;
  Navigator.pop(context!, result);
}

dynamic navigatePopUntil(String pageName) =>
    Get.until((route) => route.settings.name == pageName);

BuiltList<Route> navigationHistory() => NavigationHistoryObserver().history;

bool isNavigationExist(String pageName) {
  var list = navigationHistory();
  for (var e in list) {
    if (e.settings.name == '/$pageName') {
      return true;
    }
  }
  return false;
}

dynamic popUntilOrNavigateOff(Widget page) {
  if (isNavigationExist(page.runtimeType.toString())) {
    navigatePopUntil('/${page.runtimeType.toString()}');
  } else {
    navigateOff(page);
  }
}

dynamic navigateOffUntil(Widget page, Widget predicate) => Get.offUntil(
      GetPageRoute(
        page: () => page,
        routeName: page.runtimeType.toString(),
      ),
      (route) => route.settings.name == '/${predicate.runtimeType}',
    );
