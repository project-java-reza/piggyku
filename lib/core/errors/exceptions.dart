class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network error',
    super.code,
    super.details,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error',
    super.code,
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code,
    super.details,
  });
}

class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication error',
    super.code,
    super.details,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation error',
    super.code,
    super.details,
  });
}

class WhatsAppException extends AppException {
  const WhatsAppException({
    super.message = 'WhatsApp API error',
    super.code,
    super.details,
  });
}
