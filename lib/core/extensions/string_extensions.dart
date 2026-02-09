extension StringExtensions on String {
  // Validation Extensions
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isPhoneNumber => RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(this);
  bool get isNumeric => RegExp(r'^-?\d+\.?\d*$').hasMatch(this);
  bool get isAlphabetic => RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(this);

  // Formatting Extensions
  String get capitalizeFirst =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  String get capitalizeWords =>
      split(' ').map((word) => word.capitalizeFirst).join(' ');
  String get toSnakeCase => replaceAllMapped(
    RegExp(r'[A-Z]'),
    (match) => '_${match.group(0)!.toLowerCase()}',
  );
  String get toCamelCase => split('_')
      .map((word) => word.capitalizeFirst)
      .join()
      .replaceFirst(this[0], this[0].toLowerCase());

  // Currency Formatting
  String get toCurrency =>
      'Rp ${replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';

  // Truncation
  String truncate(int length, {String suffix = '...'}) {
    return this.length <= length ? this : '${substring(0, length)}$suffix';
  }

  // Validation with Error Messages
  String? validateEmail() {
    if (isEmpty) return 'Email is required';
    if (!isEmail) return 'Invalid email format';
    return null;
  }

  String? validatePassword() {
    if (isEmpty) return 'Password is required';
    if (length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? validateRequired(String fieldName) {
    if (isEmpty) return '$fieldName is required';
    return null;
  }

  String? validateMinLength(int minLength, String fieldName) {
    if (isEmpty) return '$fieldName is required';
    if (length < minLength)
      return '$fieldName must be at least $minLength characters';
    return null;
  }
}

extension DoubleExtensions on double {
  String get toCurrency =>
      'Rp ${toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  String toDecimal(int decimals) => toStringAsFixed(decimals);
}
