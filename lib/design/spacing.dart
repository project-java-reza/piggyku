import 'package:flutter/material.dart';

/// App Spacing Helper - Tailwind-like spacing utilities
/// Usage: p-4 → AppSpacing.md, mt-8 → AppSpacing.lg
class AppSpacing {
  // Extra small - 4px (p-1, m-1 in Tailwind)
  static const double xs = 4.0;

  // Small - 8px (p-2, m-2 in Tailwind)
  static const double sm = 8.0;

  // Medium - 16px (p-4, m-4 in Tailwind)
  static const double md = 16.0;

  // Large - 24px (p-6, m-6 in Tailwind)
  static const double lg = 24.0;

  // Extra Large - 32px (p-8, m-8 in Tailwind)
  static const double xl = 32.0;

  // 2XL - 48px (p-12, m-12 in Tailwind)
  static const double xxl = 48.0;

  // 3XL - 64px (p-16, m-16 in Tailwind)
  static const double xxxl = 64.0;

  // Edge Insets helpers for quick padding/margin
  static const allXS = EdgeInsets.all(xs);
  static const allSM = EdgeInsets.all(sm);
  static const allMD = EdgeInsets.all(md);
  static const allLG = EdgeInsets.all(lg);
  static const allXL = EdgeInsets.all(xl);

  // Symmetric padding/margin
  static const verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const verticalMD = EdgeInsets.symmetric(vertical: md);
  static const verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const verticalXL = EdgeInsets.symmetric(vertical: xl);

  static const horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const horizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // Only edges
  static const topSM = EdgeInsets.only(top: sm);
  static const topMD = EdgeInsets.only(top: md);
  static const topLG = EdgeInsets.only(top: lg);
  static const topXL = EdgeInsets.only(top: xl);

  static const bottomSM = EdgeInsets.only(bottom: sm);
  static const bottomMD = EdgeInsets.only(bottom: md);
  static const bottomLG = EdgeInsets.only(bottom: lg);
  static const bottomXL = EdgeInsets.only(bottom: xl);

  static const leftSM = EdgeInsets.only(left: sm);
  static const leftMD = EdgeInsets.only(left: md);
  static const leftLG = EdgeInsets.only(left: lg);
  static const leftXL = EdgeInsets.only(left: xl);

  static const rightSM = EdgeInsets.only(right: sm);
  static const rightMD = EdgeInsets.only(right: md);
  static const rightLG = EdgeInsets.only(right: lg);
  static const rightXL = EdgeInsets.only(right: xl);
}
