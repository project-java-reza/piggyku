import 'package:flutter/material.dart';

/// App Radius Helper - Tailwind-like border radius utilities
/// Usage: rounded-sm → AppRadius.sm, rounded-lg → AppRadius.lg
class AppRadius {
  // None - 0px (rounded-none in Tailwind)
  static const double none = 0.0;

  // Extra Small - 2px
  static const double xs = 2.0;

  // Small - 4px (rounded-sm in Tailwind)
  static const double sm = 4.0;

  // Medium - 8px (rounded in Tailwind)
  static const double md = 8.0;

  // Large - 12px (rounded-lg in Tailwind)
  static const double lg = 12.0;

  // Extra Large - 16px (rounded-xl in Tailwind)
  static const double xl = 16.0;

  // 2XL - 24px (rounded-2xl in Tailwind)
  static const double xxl = 24.0;

  // 3XL - 32px (rounded-3xl in Tailwind)
  static const double xxxl = 32.0;

  // Full - 9999px (rounded-full in Tailwind)
  static const double full = 9999.0;

  // BorderRadius helpers
  static const allSM = BorderRadius.all(Radius.circular(sm));
  static const allMD = BorderRadius.all(Radius.circular(md));
  static const allLG = BorderRadius.all(Radius.circular(lg));
  static const allXL = BorderRadius.all(Radius.circular(xl));
  static const allXXL = BorderRadius.all(Radius.circular(xxl));
  static const allXXXL = BorderRadius.all(Radius.circular(xxxl));

  // Circular border radius (for CircleAvatar, etc)
  static const circularSM = Radius.circular(sm);
  static const circularMD = Radius.circular(md);
  static const circularLG = Radius.circular(lg);
  static const circularXL = Radius.circular(xl);
  static const circularXXL = Radius.circular(xxl);
  static const circularXXXL = Radius.circular(xxxl);
}
