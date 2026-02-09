import 'package:flutter/material.dart';
import 'package:finai_frontend/design/design.dart';

/// Contoh penggunaan Helper Widgets (Tailwind-like)
///
/// File ini menunjukkan berbagai cara menggunakan helper widgets
/// yang telah dibuat untuk mempermudah development Flutter.

// ============================================
// 1. PADDING & MARGIN (P, M, Gap)
// ============================================

class ExamplePadding extends StatelessWidget {
  const ExamplePadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contoh 1: Padding semua sisi
        P(
          all: AppSpacing.md,
          child: Txt.md('Padding semua sisi 16px'),
        ),

        // Contoh 2: Padding vertical & horizontal
        P(
          v: AppSpacing.lg,  // vertical 24px
          h: AppSpacing.md,  // horizontal 16px
          child: Txt.md('Padding: v=24, h=16'),
        ),

        // Contoh 3: Padding spesifik per sisi
        P(
          t: AppSpacing.md,  // top
          b: AppSpacing.sm,  // bottom
          child: Txt.md('Padding: top=16, bottom=8'),
        ),

        // Contoh 4: Gap untuk spacing
        ColW([
          const Txt.md('Item 1'),
          const Gap(AppSpacing.md),           // Gap 16px (vertikal & horizontal)
          const Txt.md('Item 2'),
          const Gap(AppSpacing.lg),           // Gap 24px
          const Txt.md('Item 3'),
        ]),

        // Contoh 5: VGap & HGap
        RowW([
          const Txt.sm('Left'),
          const HGap(AppSpacing.md),          // Horizontal gap 16px
          const Txt.sm('Right'),
        ]),
      ],
    );
  }
}

// ============================================
// 2. TEXT WIDGETS (Txt)
// ============================================

class ExampleText extends StatelessWidget {
  const ExampleText({super.key});

  @override
  Widget build(BuildContext context) {
    return ColW(
      gap: AppSpacing.md,
      [
        // Heading dengan predefined constructors
        const Txt.h1('Heading 1 - 32px Bold'),
        const Txt.h2('Heading 2 - 28px Bold'),
        const Txt.h3('Heading 3 - 24px Bold'),
        const Txt.h4('Heading 4 - 20px Semibold'),
        const Txt.h5('Heading 5 - 18px Semibold'),
        const Txt.h6('Heading 6 - 16px Semibold'),

        // Body text
        const Txt.xl('Extra Large - 18px'),
        const Txt.lg('Large - 16px'),
        const Txt.md('Medium - 14px'),
        const Txt.sm('Small - 12px'),
        const Txt.xs('Extra Small - 10px'),

        // Custom color
        const Txt.md(
          'Text dengan warna primary',
          color: AppColors.primary,
        ),

        // Custom size
        Txt(
          'Custom 20px',
          size: 20,
        ),

        // Max lines & overflow
        const Txt.md(
          'Text yang sangat panjang dan akan di-truncate dengan titik tiga di akhir jika melebihi batas maxLines yang ditentukan',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============================================
// 3. CONTAINER WIDGET (C)
// ============================================

class ExampleContainer extends StatelessWidget {
  const ExampleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ColW(
      gap: AppSpacing.md,
      [
        // Contoh 1: Container sederhana
        C(
          color: AppColors.primary,
          p: AppSpacing.md,
          radius: AppRadius.md,
          child: const Txt.md('Container dengan warna primary'),
        ),

        // Contoh 2: Container dengan border
        C(
          color: AppColors.bgWhite,
          p: AppSpacing.md,
          radius: AppRadius.lg,
          border: Border.all(color: AppColors.border),
          child: const Txt.md('Container dengan border'),
        ),

        // Contoh 3: Container dengan shadow
        C(
          color: AppColors.bgWhite,
          p: AppSpacing.lg,
          radius: AppRadius.xl,
          shadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          child: const Txt.md('Container dengan shadow'),
        ),

        // Contoh 4: Container dengan ukuran tetap
        C(
          width: 200,
          height: 100,
          color: AppColors.secondary,
          radius: AppRadius.md,
          alignment: Alignment.center,
          child: const Txt.md('200x100'),
        ),
      ],
    );
  }
}

// ============================================
// 4. ROW & COLUMN DENGAN GAP (RowW, ColW)
// ============================================

class ExampleRowColumn extends StatelessWidget {
  const ExampleRowColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ColW(
      gap: AppSpacing.lg,
      [
        // Contoh 1: Column dengan gap
        C(
          color: AppColors.bgGray,
          p: AppSpacing.md,
          child: ColW(
            gap: AppSpacing.sm,
            [
              const Txt.md('Item 1'),
              const Txt.md('Item 2'),
              const Txt.md('Item 3'),
            ],
          ),
        ),

        // Contoh 2: Row dengan gap
        RowW(
          gap: AppSpacing.md,
          [
            C(
              width: 60,
              height: 60,
              color: AppColors.primary,
              radius: AppRadius.sm,
              child: const SizedBox(),
            ),
            C(
              width: 60,
              height: 60,
              color: AppColors.secondary,
              radius: AppRadius.sm,
              child: const SizedBox(),
            ),
            C(
              width: 60,
              height: 60,
              color: AppColors.success,
              radius: AppRadius.sm,
              child: const SizedBox(),
            ),
          ],
        ),

        // Contoh 3: Nested Row & Column
        ColW(
          gap: AppSpacing.md,
          [
            RowW(
              gap: AppSpacing.sm,
              alignment: MainAxisAlignment.spaceBetween,
              [
                const Txt.sm('Label'),
                const Txt.sm('Value', color: AppColors.textSecondary),
              ],
            ),
            RowW(
              gap: AppSpacing.sm,
              alignment: MainAxisAlignment.spaceBetween,
              [
                const Txt.sm('Status'),
                const Txt.sm('Active', color: AppColors.success),
              ],
            ),
          ],
        ),

        // Contoh 4: Row dengan alignment
        RowW(
          gap: AppSpacing.md,
          alignment: MainAxisAlignment.center,
          [
            const Txt.md('Item 1'),
            const Txt.md('Item 2'),
            const Txt.md('Item 3'),
          ],
        ),
      ],
    );
  }
}

// ============================================
// 5. COMPLEX EXAMPLE
// ============================================

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return C(
      color: AppColors.bgWhite,
      p: AppSpacing.lg,
      radius: AppRadius.lg,
      border: Border.all(color: AppColors.border),
      child: ColW(
        gap: AppSpacing.md,
        [
          // Header
          RowW(
            gap: AppSpacing.md,
            [
              C(
                width: 50,
                height: 50,
                radius: AppRadius.full,
                color: AppColors.primary,
                alignment: Alignment.center,
                child: const Txt.md('A', color: AppColors.textPrimary),
              ),
              ExpandedW(
                child: ColW(
                  gap: AppSpacing.xs,
                  [
                    const Txt.h5('John Doe'),
                    const Txt.sm('Software Engineer', color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),

          // Description
          const Txt.md(
            'Ini adalah contoh card yang menggunakan helper widgets. '
            'Card ini memiliki avatar, nama, title, dan description.',
            color: AppColors.textSecondary,
          ),

          // Actions
          RowW(
            gap: AppSpacing.sm,
            [
              ExpandedW(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Txt.md('Follow'),
                ),
              ),
              ExpandedW(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Txt.md('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// 6. FORM EXAMPLE
// ============================================

class ExampleForm extends StatelessWidget {
  const ExampleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return C(
      color: AppColors.bgWhite,
      p: AppSpacing.lg,
      radius: AppRadius.lg,
      child: ColW(
        gap: AppSpacing.md,
        [
          const Txt.h4('Login Form'),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),

          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),

          const Gap.sm(),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              padding: AppSpacing.verticalMD,
            ),
            child: const Txt.md('Login'),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 7. COMPARISON: BEFORE vs AFTER
// ============================================

class BeforeExample extends StatelessWidget {
  const BeforeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // BEFORE (Hardcoded)
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Title',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          SizedBox(height: 8),
          C(
            p: AppSpacing.md,
            color: AppColors.bgGray,
            radius: AppRadius.md,
            child: const Txt.md('Description'),
          ),
        ],
      ),
    );
  }
}

class AfterExample extends StatelessWidget {
  const AfterExample({super.key});

  @override
  Widget build(BuildContext context) {
    // AFTER (Dengan Helper Widgets)
    return P(
      all: AppSpacing.md,
      child: ColW(
        gap: AppSpacing.md,
        [
          const Txt.h3('Title'),
          C(
            p: AppSpacing.md,
            color: AppColors.bgGray,
            radius: AppRadius.md,
            child: const Txt.md('Description'),
          ),
        ],
      ),
    );
  }
}
