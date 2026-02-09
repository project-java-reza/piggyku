import 'package:equatable/equatable.dart';

/// Base state for permission cubit
abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PermissionInitial extends PermissionState {
  const PermissionInitial();
}

/// Loading state
class PermissionLoading extends PermissionState {
  const PermissionLoading();
}

/// Permissions loaded with status
class PermissionsLoaded extends PermissionState {
  final bool notificationPermissionGranted;
  final bool alarmPermissionGranted;

  const PermissionsLoaded({
    required this.notificationPermissionGranted,
    required this.alarmPermissionGranted,
  });

  /// Check if all required permissions are granted
  bool get allPermissionsGranted =>
      notificationPermissionGranted && alarmPermissionGranted;

  @override
  List<Object?> get props => [notificationPermissionGranted, alarmPermissionGranted];

  /// Copy with method
  PermissionsLoaded copyWith({
    bool? notificationPermissionGranted,
    bool? alarmPermissionGranted,
  }) {
    return PermissionsLoaded(
      notificationPermissionGranted:
          notificationPermissionGranted ?? this.notificationPermissionGranted,
      alarmPermissionGranted: alarmPermissionGranted ?? this.alarmPermissionGranted,
    );
  }
}

/// Permission error state
class PermissionError extends PermissionState {
  final String message;

  const PermissionError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// First launch check state
class FirstLaunchCheck extends PermissionState {
  final bool isFirstLaunch;

  const FirstLaunchCheck({required this.isFirstLaunch});

  @override
  List<Object?> get props => [isFirstLaunch];
}
