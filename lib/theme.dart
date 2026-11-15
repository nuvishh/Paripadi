import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

/// Apple system colors, exactly as in the Paripadi prototype.
abstract final class AppColors {
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);
  static const Color red = Color(0xFFFF3B30);
  static const Color orange = Color(0xFFFF9500);
  static const Color purple = Color(0xFFAF52DE);
  static const Color indigo = Color(0xFF5856D6);
  static const Color lightBlue = Color(0xFF34AADC);
  static const Color pink = Color(0xFFFF2D55);
  static const Color gray = Color(0xFF8E8E93);

  // Prototype surfaces.
  static const Color lightBackground = Color(0xFFF5F5F7);
  static const Color darkCard = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF1D1D1F);
  static const Color darkSecondary = Color(0xFF2C2C2E);

  // House colors.
  static const Color redHouse = Color(0xFFEF4444);
  static const Color blueHouse = Color(0xFF3B82F6);
  static const Color greenHouse = Color(0xFF22C55E);
  static const Color yellowHouse = Color(0xFFEAB308);

  // Direction B (Bold) — v1.0.1.
  static const List<Color> heroGradient = [
    Color(0xFF1F0754),
    Color(0xFF3B1D8F),
    Color(0xFF007AFF),
  ];
  static const List<Color> matchCardGradient = [
    Color(0xFF17122B),
    Color(0xFF241A4D),
  ];
  static const Color kpiVioletLight = Color(0xFF1F0754);
  static const Color kpiVioletDark = Color(0xFFB7A6FF);

  /// KPI value color: deep violet in light mode, light violet in dark
  /// mode — #1F0754 on a dark surface would be unreadable.
  static Color kpiValue(BuildContext context) =>
      CupertinoTheme.of(context).brightness == Brightness.dark
          ? kpiVioletDark
          : kpiVioletLight;

  /// Strong secondary text: solid #3A3A3C in light mode (the 60%-alpha
  /// system secondary label was the "middle elements not visible"
  /// complaint), light grey in dark mode.
  static Color strongSecondary(BuildContext context) =>
      CupertinoTheme.of(context).brightness == Brightness.dark
          ? const Color(0xFFAEAEB2)
          : const Color(0xFF3A3A3C);

  /// Text on the dark gradient surfaces (hero, match card): white in
  /// both themes, muted lavender-grey for secondary lines.
  static const Color onDark = Color(0xFFFFFFFF);
  static const Color onDarkMuted = Color(0xFFA3A3B8);

  /// Link blue that stays readable on the dark gradient surfaces.
  static const Color linkOnDark = Color(0xFF64D2FF);

  /// Dark-mode variants of the brand colors (iOS dark palette): the
  /// standard blues/greens read too dark on #1C1C1E surfaces, so text
  /// and icons painted with a brand color go through this in dark mode.
  static Color readable(Color color, BuildContext context) {
    if (CupertinoTheme.of(context).brightness != Brightness.dark) {
      return color;
    }
    if (color == blue) return const Color(0xFF0A84FF);
    if (color == green) return const Color(0xFF30D158);
    if (color == orange) return const Color(0xFFFF9F0A);
    if (color == red) return const Color(0xFFFF453A);
    if (color == purple) return const Color(0xFFBF5AF2);
    if (color == pink) return const Color(0xFFFF375F);
    if (color == indigo) return const Color(0xFF5E5CE6);
    return color;
  }
}

/// Inter is the closest free match to SF Pro; Cupertino text styles carry
/// the iOS typography scale (large title 34, title 22/20, body 17, etc.).
abstract final class AppText {
  static TextStyle largeTitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: CupertinoTheme.of(context).textTheme.textStyle.color,
      );

  static TextStyle title(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle headline(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle body(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(fontSize: 15, color: color);

  static TextStyle subheadline(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(fontSize: 13, color: color);

  static TextStyle footnote(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(fontSize: 12, color: color);

  static TextStyle caption(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(fontSize: 11, color: color);

  static TextStyle kpiValue(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.kpiValue(context),
      );
}

/// iOS inset-grouped card: 24px squircle, adaptive background, hairline border.
class IosCard extends StatelessWidget {
  const IosCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final isDark =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : CupertinoColors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? CupertinoColors.white.withValues(alpha: 0.10)
              : CupertinoColors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withValues(alpha: isDark ? 0.45 : 0.04),
            blurRadius: isDark ? 24 : 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small uppercase section label, iOS style. Defaults to the strong
/// secondary color so it stays readable in both themes; pass [color]
/// for labels sitting on the dark gradient surfaces.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: color ?? AppColors.strongSecondary(context),
        ),
      ),
    );
  }
}

/// Pill badge (Live, Active, Checked In, ...).
class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    required this.color,
    this.filled = false,
  });

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled
            ? color
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: filled
              ? CupertinoColors.white
              : AppColors.readable(color, context),
        ),
      ),
    );
  }
}

/// Round icon tile used in KPI cards and rows.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = 36,
    this.iconSize = 17,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: iconSize, color: AppColors.readable(color, context)),
    );
  }
}

/// Direction B full-width gradient hero header (top of Overview):
/// violet → indigo → blue with rounded bottom corners. Title and
/// tagline sit on it in white in both themes.
class GradientHero extends StatelessWidget {
  const GradientHero({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: child,
    );
  }
}

/// Direction B in-content gradient card (hero headers on Events, Passes,
/// Create): same gradient, 24px radius all round.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x331F0754),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Direction B dark gradient card (live match control): dark navy
/// gradient in BOTH themes — every text inside must be white or
/// [AppColors.onDarkMuted], never a theme label color.
class DarkGradientCard extends StatelessWidget {
  const DarkGradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.matchCardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x4017122B),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
