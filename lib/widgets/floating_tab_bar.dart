import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Direction B floating pill tab bar (v1.0.1): detached 16px from the
/// edges, dark glass with blur, active tab = filled blue pill with white
/// icon + label, inactive tabs = translucent white. Same look in light
/// and dark mode — it floats over the content, never a full-width bar
/// pinned to the bottom edge.
class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<(IconData, String)> _items = [
    (CupertinoIcons.square_grid_2x2, 'Bento'),
    (CupertinoIcons.calendar, 'Events'),
    (CupertinoIcons.ticket, 'Passes'),
    (CupertinoIcons.plus_circle, 'Create'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _items.length; i++) _tab(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(int index) {
    final active = index == currentIndex;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _items[index].$1,
          size: 21,
          color: CupertinoColors.white.withValues(alpha: active ? 1 : 0.55),
        ),
        const SizedBox(height: 2),
        Text(
          _items[index].$2,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: CupertinoColors.white.withValues(alpha: active ? 1 : 0.55),
          ),
        ),
      ],
    );
    final padded = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: content,
    );
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: active
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: padded,
            )
          : padded,
    );
  }
}
