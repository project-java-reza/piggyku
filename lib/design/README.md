# Design Helper - Tailwind-like Utilities

Helper files untuk mempermudah styling di Flutter mirip Tailwind CSS.

## Struktur File

```
lib/design/
├─ colors.dart      # Warna-warna aplikasi
├─ spacing.dart     # Spacing (padding, margin)
├─ radius.dart      # Border radius
├─ text_styles.dart # Text styles
└─ README.md        # Dokumentasi ini
```

## Cara Penggunaan

### 1. Import helper yang dibutuhkan

**Cara 1: Import semua sekaligus (Recommended)**
```dart
import 'package:finai_frontend/design/design.dart';
```

**Cara 2: Import per file**
```dart
import 'package:finai_frontend/design/colors.dart';
import 'package:finai_frontend/design/spacing.dart';
import 'package:finai_frontend/design/radius.dart';
import 'package:finai_frontend/design/text_styles.dart';
```

### 2. Colors (colors.dart)

```dart
// Background colors
Container(
  color: AppColors.bgTop,
  child: Text('Background Top'),
)

Container(
  color: AppColors.bgWhite,
  child: Text('Background White'),
)

// Text colors
Text(
  'Hello World',
  style: TextStyle(color: AppColors.textPrimary),
)

// Status colors
Text(
  'Success',
  style: TextStyle(color: AppColors.success),
)
```

### 3. Spacing (spacing.dart)

```dart
// Padding
Padding(
  padding: AppSpacing.allMD,      // padding: 16px semua sisi (p-4)
  child: Text('Padding Medium'),
)

Padding(
  padding: AppSpacing.horizontalLG, // horizontal: 24px (px-6)
  child: Text('Padding Horizontal'),
)

// Margin
SizedBox(height: AppSpacing.md),    // 16px (mt-4 atau mb-4)
SizedBox(width: AppSpacing.lg),     // 24px (ml-6 atau mr-6)

// Nilai spacing yang tersedia:
// AppSpacing.xs  = 4px   (p-1)
// AppSpacing.sm  = 8px   (p-2)
// AppSpacing.md  = 16px  (p-4)
// AppSpacing.lg  = 24px  (p-6)
// AppSpacing.xl  = 32px  (p-8)
// AppSpacing.xxl = 48px  (p-12)
// AppSpacing.xxxl = 64px (p-16)
```

### 4. Radius (radius.dart)

```dart
// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.allMD,    // 8px (rounded)
    color: AppColors.bgWhite,
  ),
  child: Text('Rounded Container'),
)

Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.allXL,    // 16px (rounded-xl)
    color: AppColors.primary,
  ),
)

// Nilai radius yang tersedia:
// AppRadius.none  = 0px    (rounded-none)
// AppRadius.sm    = 4px    (rounded-sm)
// AppRadius.md    = 8px    (rounded)
// AppRadius.lg    = 12px   (rounded-lg)
// AppRadius.xl    = 16px   (rounded-xl)
// AppRadius.xxl   = 24px   (rounded-2xl)
// AppRadius.xxxl  = 32px   (rounded-3xl)
// AppRadius.full  = 9999px (rounded-full)
```

### 5. Text Styles (text_styles.dart)

```dart
// Heading styles
Text('Heading 1', style: AppTextStyles.h1)     // 32px, bold
Text('Heading 2', style: AppTextStyles.h2)     // 28px, bold
Text('Heading 3', style: AppTextStyles.h3)     // 24px, bold
Text('Heading 4', style: AppTextStyles.h4)     // 20px, semibold
Text('Heading 5', style: AppTextStyles.h5)     // 18px, semibold
Text('Heading 6', style: AppTextStyles.h6)     // 16px, semibold

// Body text
Text('Large text', style: AppTextStyles.xl)    // 18px
Text('Normal text', style: AppTextStyles.lg)   // 16px
Text('Medium text', style: AppTextStyles.md)   // 14px
Text('Small text', style: AppTextStyles.sm)    // 12px
Text('Extra small', style: AppTextStyles.xs)   // 10px

// Button & Special styles
Text('Button', style: AppTextStyles.button)
Text('Caption', style: AppTextStyles.caption)
Text('Overline', style: AppTextStyles.overline)

// Helper methods
Text(
  'Custom color',
  style: AppTextStyles.withColor(AppTextStyles.lg, AppColors.primary),
)
```

## Contoh Implementasi Lengkap

```dart
import 'package:flutter/material.dart';
import 'package:finai_frontend/design/design.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.allMD,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: AppRadius.allLG,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Judul Artikel',
            style: AppTextStyles.h4,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Ini adalah contoh paragraf dengan menggunakan helper design.',
            style: AppTextStyles.md,
          ),
          SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              padding: AppSpacing.horizontalMD,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allMD,
              ),
            ),
            child: Text('Tombol', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
```

## Keuntungan Menggunakan Helper Ini

1. **Konsistensi** - Semua spacing, warna, dan radius konsisten di seluruh aplikasi
2. **Mudah di-maintain** - Ubah di satu tempat, berubah di semua tempat
3 **Readability** - Code lebih mudah dibaca dengan `AppSpacing.md` daripada `const SizedBox(height: 16.0)`
4. **Tailwind-like** - Syntax yang mirip dengan Tailwind CSS untuk developer yang sudah terbiasa

## Tips

- Gunakan `AppSpacing` constants bukan hardcoded numbers
- Gunakan `AppTextStyles` untuk text yang sering digunakan
- Gunakan `AppColors` untuk semua warna, jangan hardcode
- Helper ini bisa dikombinasikan dengan `Theme.of(context)` jika needed
