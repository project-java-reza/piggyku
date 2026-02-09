import 'package:bloc/bloc.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_state.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit for managing app permissions
class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(const PermissionInitial());

  static const String _firstLaunchKey = 'isFirstLaunch';

  /// Check if this is the first launch of the app
  Future<void> checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

      emit(FirstLaunchCheck(isFirstLaunch: isFirstLaunch));
    } catch (e) {
      emit(PermissionError(message: 'Failed to check first launch: $e'));
    }
  }

  /// Set first launch flag to false
  Future<void> setFirstLaunchCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, false);
    } catch (e) {
      emit(PermissionError(message: 'Failed to set first launch: $e'));
    }
  }

  /// Check current permission status
  Future<void> checkPermissions() async {
    try {
      emit(const PermissionLoading());

      // Check notification permission
      final notificationStatus = await ph.Permission.notification.status;

      // Check alarm/schedule exact alarm permission (Android 12+)
      final alarmStatus = await ph.Permission.scheduleExactAlarm.status;

      emit(PermissionsLoaded(
        notificationPermissionGranted: notificationStatus.isGranted,
        alarmPermissionGranted: alarmStatus.isGranted,
      ));
    } catch (e) {
      emit(PermissionError(message: 'Failed to check permissions: $e'));
    }
  }

  /// Request notification permission
  Future<void> requestNotificationPermission() async {
    try {
      final currentState = state;
      if (currentState is! PermissionsLoaded) {
        await checkPermissions();
        return;
      }

      final status = await ph.Permission.notification.request();

      emit(currentState.copyWith(
        notificationPermissionGranted: status.isGranted,
      ));
    } catch (e) {
      emit(PermissionError(message: 'Failed to request notification permission: $e'));
    }
  }

  /// Request alarm/schedule exact alarm permission
  Future<void> requestAlarmPermission() async {
    try {
      final currentState = state;
      if (currentState is! PermissionsLoaded) {
        await checkPermissions();
        return;
      }

      final status = await ph.Permission.scheduleExactAlarm.request();

      emit(currentState.copyWith(
        alarmPermissionGranted: status.isGranted,
      ));
    } catch (e) {
      emit(PermissionError(message: 'Failed to request alarm permission: $e'));
    }
  }

  /// Request all permissions
  Future<void> requestAllPermissions() async {
    try {
      emit(const PermissionLoading());

      // Request notification permission
      final notificationStatus = await ph.Permission.notification.request();

      // Request alarm/schedule exact alarm permission
      final alarmStatus = await ph.Permission.scheduleExactAlarm.request();

      emit(PermissionsLoaded(
        notificationPermissionGranted: notificationStatus.isGranted,
        alarmPermissionGranted: alarmStatus.isGranted,
      ));
    } catch (e) {
      emit(PermissionError(message: 'Failed to request permissions: $e'));
    }
  }

  /// Open app settings for manual permission grant
  Future<void> openSettings() async {
    try {
      final opened = await ph.openAppSettings();
      if (!opened) {
        emit(const PermissionError(message: 'Failed to open app settings'));
      }
    } catch (e) {
      emit(PermissionError(message: 'Failed to open settings: $e'));
    }
  }

  /// Complete permission setup and mark first launch as done
  Future<void> completePermissionSetup() async {
    await setFirstLaunchCompleted();
  }

  /// Reset first launch flag (for testing purposes)
  Future<void> resetFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, true);
      await checkFirstLaunch();
    } catch (e) {
      emit(PermissionError(message: 'Failed to reset first launch: $e'));
    }
  }
}
