class AppFailure {
  final String message;
  final int? code;
  final String? details;

  const AppFailure({required this.message, this.code, this.details});

  @override
  String toString() => message;
}

// Network Failures
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'Network error occurred',
    super.code,
    super.details,
  });
}

class ConnectionFailure extends AppFailure {
  const ConnectionFailure({
    super.message = 'No internet connection',
    super.code,
    super.details,
  });
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'Request timeout',
    super.code,
    super.details,
  });
}

// Server Failures
class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
    super.details,
  });
}

class AuthFailure extends AppFailure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code,
    super.details,
  });
}

class ValidationFailure extends AppFailure {
  const ValidationFailure({
    super.message = 'Validation error',
    super.code,
    super.details,
  });
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code,
    super.details,
  });
}

class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure({
    super.message = 'Access forbidden',
    super.code,
    super.details,
  });
}

// Cache Failures
class CacheFailure extends AppFailure {
  const CacheFailure({
    super.message = 'Cache error',
    super.code,
    super.details,
  });
}

// WhatsApp Failures
class WhatsAppFailure extends AppFailure {
  const WhatsAppFailure({
    super.message = 'WhatsApp service error',
    super.code,
    super.details,
  });
}

// General Failures
class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = 'Unknown error occurred',
    super.code,
    super.details,
  });
}
