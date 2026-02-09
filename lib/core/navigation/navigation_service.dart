import 'package:flutter/material.dart';

/// Generic Navigation Service untuk mengelola navigasi di seluruh aplikasi
/// Menggunakan Navigation v1 dengan berbagai method navigasi
class NavigationService {
  // Global navigator key untuk mengakses navigator dari mana saja
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Getter untuk mendapatkan navigator state
  static NavigatorState? get navigator => navigatorKey.currentState;

  // Getter untuk mendapatkan current context
  static BuildContext? get context => navigatorKey.currentContext;

  /// Push halaman baru ke stack
  /// [page] - Widget halaman yang akan ditampilkan
  /// [settings] - RouteSettings optional untuk konfigurasi route
  static Future<T?> push<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
  }) {
    return navigator!.push<T>(
      MaterialPageRoute<T>(builder: (_) => page, settings: settings),
    );
  }

  /// Push halaman baru dengan named route
  /// [routeName] - Nama route yang akan dipush
  /// [arguments] - Arguments yang akan dikirim ke route
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace halaman saat ini dengan halaman baru
  /// [page] - Widget halaman yang akan menggantikan halaman saat ini
  /// [settings] - RouteSettings optional untuk konfigurasi route
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    RouteSettings? settings,
    TO? result,
  }) {
    return navigator!.pushReplacement<T, TO>(
      MaterialPageRoute<T>(builder: (_) => page, settings: settings),
      result: result,
    );
  }

  /// Replace halaman saat ini dengan named route
  /// [routeName] - Nama route yang akan menggantikan halaman saat ini
  /// [arguments] - Arguments yang akan dikirim ke route
  /// [result] - Result yang akan dikembalikan ke halaman sebelumnya
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Push halaman baru dan hapus semua halaman sebelumnya berdasarkan predicate
  /// [page] - Widget halaman yang akan ditampilkan
  /// [predicate] - Function untuk menentukan halaman mana yang akan dihapus
  /// [settings] - RouteSettings optional untuk konfigurasi route
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget page,
    RoutePredicate predicate, {
    RouteSettings? settings,
  }) {
    return navigator!.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(builder: (_) => page, settings: settings),
      predicate,
    );
  }

  /// Push halaman baru dengan named route dan hapus halaman sebelumnya berdasarkan predicate
  /// [routeName] - Nama route yang akan ditampilkan
  /// [predicate] - Function untuk menentukan halaman mana yang akan dihapus
  /// [arguments] - Arguments yang akan dikirim ke route
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Kembali ke halaman sebelumnya
  /// [result] - Result yang akan dikembalikan ke halaman sebelumnya
  static void pop<T extends Object?>([T? result]) {
    if (canPop()) {
      navigator!.pop<T>(result);
    }
  }

  /// Kembali ke halaman tertentu berdasarkan predicate
  /// [predicate] - Function untuk menentukan halaman mana yang akan dikembalikan
  /// [result] - Result yang akan dikembalikan
  static void popUntil<T extends Object?>(
    RoutePredicate predicate, [
    T? result,
  ]) {
    navigator!.popUntil(predicate);
  }

  /// Kembali ke named route tertentu
  /// [routeName] - Nama route yang akan dikembalikan
  /// [result] - Result yang akan dikembalikan
  static void popUntilNamed<T extends Object?>(String routeName, [T? result]) {
    navigator!.popUntil(ModalRoute.withName(routeName));
  }

  /// Cek apakah bisa melakukan pop (ada halaman sebelumnya)
  static bool canPop() {
    return navigator?.canPop() ?? false;
  }

  /// Pop semua halaman dan push halaman baru (clear stack)
  /// [page] - Widget halaman yang akan ditampilkan
  /// [settings] - RouteSettings optional untuk konfigurasi route
  static Future<T?> pushAndClearStack<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
  }) {
    return pushAndRemoveUntil<T>(
      page,
      (route) => false, // Remove all previous routes
      settings: settings,
    );
  }

  /// Pop semua halaman dan push named route baru (clear stack)
  /// [routeName] - Nama route yang akan ditampilkan
  /// [arguments] - Arguments yang akan dikirim ke route
  static Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false, // Remove all previous routes
      arguments: arguments,
    );
  }

  /// Show dialog dengan widget custom
  /// [child] - Widget yang akan ditampilkan dalam dialog
  /// [barrierDismissible] - Apakah dialog bisa ditutup dengan tap di luar
  /// [barrierColor] - Warna barrier di belakang dialog
  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (_) => child,
    );
  }

  /// Show alert dialog dengan title, content, dan actions
  /// [title] - Judul dialog
  /// [content] - Konten dialog
  /// [actions] - List actions (buttons) dalam dialog
  static Future<T?> showAlertDialog<T>({
    String? title,
    String? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: actions,
      ),
    );
  }

  /// Show confirmation dialog dengan OK dan Cancel button
  /// [title] - Judul dialog
  /// [content] - Konten dialog
  /// [confirmText] - Text untuk button confirm (default: "OK")
  /// [cancelText] - Text untuk button cancel (default: "Cancel")
  static Future<bool?> showConfirmationDialog({
    String? title,
    String? content,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    return showAlertDialog<bool>(
      title: title,
      content: content,
      actions: [
        TextButton(onPressed: () => pop(false), child: Text(cancelText)),
        TextButton(onPressed: () => pop(true), child: Text(confirmText)),
      ],
    );
  }

  /// Show bottom sheet
  /// [child] - Widget yang akan ditampilkan dalam bottom sheet
  /// [isScrollControlled] - Apakah bottom sheet bisa di-scroll
  /// [isDismissible] - Apakah bottom sheet bisa ditutup dengan swipe down
  /// [enableDrag] - Apakah bottom sheet bisa di-drag
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (_) => child,
    );
  }

  /// Show snackbar
  /// [message] - Pesan yang akan ditampilkan
  /// [duration] - Durasi snackbar ditampilkan
  /// [action] - Action button dalam snackbar
  /// [backgroundColor] - Warna background snackbar
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
          backgroundColor: backgroundColor,
        ),
      );
    }
  }

  /// Hide current snackbar
  static void hideSnackBar() {
    if (context != null) {
      ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    }
  }

  /// Get current route name
  static String? getCurrentRouteName() {
    String? routeName;
    navigator?.popUntil((route) {
      routeName = route.settings.name;
      return true;
    });
    return routeName;
  }

  /// Check if current route is specific route name
  /// [routeName] - Nama route yang akan dicek
  static bool isCurrentRoute(String routeName) {
    return getCurrentRouteName() == routeName;
  }

  /// Navigate to login and clear all previous routes
  static Future<void> navigateToLogin({String loginRoute = '/login'}) {
    return pushNamedAndClearStack(loginRoute);
  }

  /// Navigate to home/dashboard and clear all previous routes
  static Future<void> navigateToHome({String homeRoute = '/dashboard'}) {
    return pushNamedAndClearStack(homeRoute);
  }

  /// Custom page transition animation
  static PageRouteBuilder<T> createCustomRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TransitionType transitionType = TransitionType.slideRight,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation: animation,
          child: child,
          transitionType: transitionType,
          curve: curve,
        );
      },
    );
  }

  /// Push dengan custom transition
  static Future<T?> pushWithCustomTransition<T extends Object?>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TransitionType transitionType = TransitionType.slideRight,
  }) {
    return navigator!.push<T>(
      createCustomRoute<T>(
        page: page,
        settings: settings,
        duration: duration,
        curve: curve,
        transitionType: transitionType,
      ),
    );
  }

  static Widget _buildTransition({
    required Animation<double> animation,
    required Widget child,
    required TransitionType transitionType,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (transitionType) {
      case TransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case TransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case TransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case TransitionType.fade:
        return FadeTransition(opacity: curvedAnimation, child: child);
      case TransitionType.scale:
        return ScaleTransition(scale: curvedAnimation, child: child);
      case TransitionType.rotation:
        return RotationTransition(turns: curvedAnimation, child: child);
    }
  }
}

/// Enum untuk tipe transisi custom
enum TransitionType {
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  fade,
  scale,
  rotation,
}

/// Extension untuk kemudahan akses NavigationService
extension NavigationExtension on Widget {
  /// Push halaman ini ke navigator
  Future<T?> push<T extends Object?>() {
    return NavigationService.push<T>(this);
  }

  /// Replace halaman saat ini dengan halaman ini
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>({
    TO? result,
  }) {
    return NavigationService.pushReplacement<T, TO>(this, result: result);
  }

  /// Push halaman ini dan hapus semua halaman sebelumnya
  Future<T?> pushAndClearStack<T extends Object?>() {
    return NavigationService.pushAndClearStack<T>(this);
  }

  /// Push halaman ini dengan custom transition
  Future<T?> pushWithTransition<T extends Object?>({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TransitionType transitionType = TransitionType.slideRight,
  }) {
    return NavigationService.pushWithCustomTransition<T>(
      page: this,
      duration: duration,
      curve: curve,
      transitionType: transitionType,
    );
  }
}
