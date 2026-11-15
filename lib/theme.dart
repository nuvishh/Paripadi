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
}

/// Inter is the closest free match to SF Pro; Cupertino text styles carry
/// the iOS typography scale (large title 34, title 22/20, body 17, etc.).
abstract final class AppText {
  static TextStyle largeTitle(BuildContext context) => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: CupertinoTheme.of(context).textTheme.textStyle.color,
      );

  static TextStyle title(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle headline(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
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
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color,
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
            : CupertinoColors.white.withValues(alpha: 0.78),
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

/// Small uppercase section label, iOS style.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

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
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
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
          color: filled ? CupertinoColors.white : color,
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
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
