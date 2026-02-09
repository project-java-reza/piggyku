import 'package:flutter/material.dart';
import 'colors.dart';
import 'spacing.dart';
import 'radius.dart';
import 'text_styles.dart';

/// Padding Widget - Tailwind-like padding helper
/// Usage: P(v: AppSpacing.lg, h: AppSpacing.md, child: Text('Hello'))
class P extends StatelessWidget {
  final Widget child;
  final double v; // vertical padding
  final double h; // horizontal padding
  final double? all; // all padding if specified
  final double? t; // top
  final double? b; // bottom
  final double? l; // left
  final double? r; // right

  const P({
    super.key,
    required this.child,
    this.v = 0,
    this.h = 0,
    this.all,
    this.t,
    this.b,
    this.l,
    this.r,
  });

  @override
  Widget build(BuildContext context) {
    if (all != null) {
      return Padding(padding: EdgeInsets.all(all!), child: child);
    }

    if (t != null || b != null || l != null || r != null) {
      return Padding(
        padding: EdgeInsets.only(
          top: t ?? 0,
          bottom: b ?? 0,
          left: l ?? 0,
          right: r ?? 0,
        ),
        child: child,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: v, horizontal: h),
      child: child,
    );
  }
}

/// Margin Widget - Tailwind-like margin helper using SizedBox
/// Usage: M(v: AppSpacing.md) or M(h: AppSpacing.lg)
class M extends StatelessWidget {
  final Widget child;
  final double v; // vertical margin (top & bottom)
  final double h; // horizontal margin (left & right)
  final double? all; // all margin if specified
  final double? t; // top
  final double? b; // bottom
  final double? l; // left
  final double? r; // right

  const M({
    super.key,
    required this.child,
    this.v = 0,
    this.h = 0,
    this.all,
    this.t,
    this.b,
    this.l,
    this.r,
  });

  @override
  Widget build(BuildContext context) {
    if (all != null) {
      return Padding(
        padding: EdgeInsets.all(all!),
        child: child,
      );
    }

    if (t != null || b != null || l != null || r != null) {
      return Padding(
        padding: EdgeInsets.only(
          top: t ?? 0,
          bottom: b ?? 0,
          left: l ?? 0,
          right: r ?? 0,
        ),
        child: child,
      );
    }

    if (v == 0 && h == 0) return child;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: v, horizontal: h),
      child: child,
    );
  }
}

/// Gap Widget - SizedBox for spacing between widgets
/// Usage: Gap(AppSpacing.md)
class Gap extends StatelessWidget {
  final double size;

  const Gap(this.size, {super.key});

  const Gap.xs({super.key}) : size = AppSpacing.xs;
  const Gap.sm({super.key}) : size = AppSpacing.sm;
  const Gap.md({super.key}) : size = AppSpacing.md;
  const Gap.lg({super.key}) : size = AppSpacing.lg;
  const Gap.xl({super.key}) : size = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size);
  }
}

/// VGap - Vertical gap (height only)
/// Usage: VGap(AppSpacing.md)
class VGap extends StatelessWidget {
  final double height;

  const VGap(this.height, {super.key});

  const VGap.xs({super.key}) : height = AppSpacing.xs;
  const VGap.sm({super.key}) : height = AppSpacing.sm;
  const VGap.md({super.key}) : height = AppSpacing.md;
  const VGap.lg({super.key}) : height = AppSpacing.lg;
  const VGap.xl({super.key}) : height = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// HGap - Horizontal gap (width only)
/// Usage: HGap(AppSpacing.md)
class HGap extends StatelessWidget {
  final double width;

  const HGap(this.width, {super.key});

  const HGap.xs({super.key}) : width = AppSpacing.xs;
  const HGap.sm({super.key}) : width = AppSpacing.sm;
  const HGap.md({super.key}) : width = AppSpacing.md;
  const HGap.lg({super.key}) : width = AppSpacing.lg;
  const HGap.xl({super.key}) : width = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

/// Container Widget - Tailwind-like container helper
class C extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  final double? p; // padding
  final double? radius; // border radius
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final AlignmentGeometry? alignment;
  final BoxDecoration? decoration;

  const C({
    super.key,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.p,
    this.radius,
    this.border,
    this.shadow,
    this.alignment,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: p != null ? EdgeInsets.all(p!) : null,
      alignment: alignment,
      decoration: decoration ??
          BoxDecoration(
            color: color,
            borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
            border: border,
            boxShadow: shadow,
          ),
      child: child,
    );
  }
}

/// Text Widget - Tailwind-like text helper
class Txt extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  const Txt(
    this.text, {
    super.key,
    this.style,
    this.align,
    this.maxLines,
    this.overflow,
    this.color,
    this.size,
    this.weight,
  });

  // Predefined constructors
  const Txt.h1(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h1,
        color = color,
        size = null,
        weight = null;

  const Txt.h2(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h2,
        color = color,
        size = null,
        weight = null;

  const Txt.h3(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h3,
        color = color,
        size = null,
        weight = null;

  const Txt.h4(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h4,
        color = color,
        size = null,
        weight = null;

  const Txt.h5(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h5,
        color = color,
        size = null,
        weight = null;

  const Txt.h6(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.h6,
        color = color,
        size = null,
        weight = null;

  const Txt.xl(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.xl,
        color = color,
        size = null,
        weight = null;

  const Txt.lg(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.lg,
        color = color,
        size = null,
        weight = null;

  const Txt.md(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.md,
        color = color,
        size = null,
        weight = null;

  const Txt.sm(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.sm,
        color = color,
        size = null,
        weight = null;

  const Txt.xs(
    this.text, {
    super.key,
    this.align,
    this.maxLines,
    this.overflow,
    Color? color,
  })  : style = AppTextStyles.xs,
        color = color,
        size = null,
        weight = null;

  @override
  Widget build(BuildContext context) {
    TextStyle finalStyle = style ?? const TextStyle();

    if (color != null) {
      finalStyle = finalStyle.copyWith(color: color!);
    }
    if (size != null) {
      finalStyle = finalStyle.copyWith(fontSize: size!);
    }
    if (weight != null) {
      finalStyle = finalStyle.copyWith(fontWeight: weight!);
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// RowW - Row with gap spacing
class RowW extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final MainAxisAlignment? alignment;
  final CrossAxisAlignment? crossAlignment;
  final MainAxisSize? size;

  const RowW(
    this.children, {
    super.key,
    this.gap = 0,
    this.alignment,
    this.crossAlignment,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: size ?? MainAxisSize.max,
      children: _addGap(),
    );
  }

  List<Widget> _addGap() {
    if (gap == 0) return children;
    if (children.isEmpty) return children;

    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap));
      }
    }
    return result;
  }
}

/// ColW - Column with gap spacing
class ColW extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final MainAxisAlignment? alignment;
  final CrossAxisAlignment? crossAlignment;
  final MainAxisSize? size;

  const ColW(
    this.children, {
    super.key,
    this.gap = 0,
    this.alignment,
    this.crossAlignment,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: size ?? MainAxisSize.max,
      children: _addGap(),
    );
  }

  List<Widget> _addGap() {
    if (gap == 0) return children;
    if (children.isEmpty) return children;

    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(height: gap));
      }
    }
    return result;
  }
}

/// CenterW - Center widget
class CenterW extends StatelessWidget {
  final Widget child;

  const CenterW({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(child: child);
  }
}

/// ExpandedW - Expanded widget
class ExpandedW extends StatelessWidget {
  final Widget child;
  final int flex;

  const ExpandedW({super.key, required this.child, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}

/// FlexibleW - Flexible widget
class FlexibleW extends StatelessWidget {
  final Widget child;
  final int flex;
  final FlexFit fit;

  const FlexibleW({
    super.key,
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}
