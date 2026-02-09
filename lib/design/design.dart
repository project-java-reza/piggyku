/// Design System - Tailwind-like utilities for Flutter
///
/// Export semua helper design dalam satu file
///
/// Usage:
/// ```dart
/// import 'package:finai_frontend/design/design.dart';
///
/// // Menggunakan colors
/// Container(color: AppColors.primary)
///
/// // Menggunakan spacing
/// Padding(padding: AppSpacing.allMD)
///
/// // Menggunakan radius
/// BorderRadius.circular(AppRadius.lg)
///
/// // Menggunakan text styles
/// Text('Hello', style: AppTextStyles.h3)
///
/// // Menggunakan widgets (Tailwind-like)
/// P(v: AppSpacing.lg, h: AppSpacing.md, child: Text('Hello'))
/// Gap.md
/// Txt.md('Hello World')
/// RowW([Text('A'), Text('B')], gap: AppSpacing.sm)
/// ```

library;

export 'colors.dart';
export 'spacing.dart';
export 'radius.dart';
export 'text_styles.dart';
export 'widgets.dart';
export 'widgets/pig_cool_loading.dart';
