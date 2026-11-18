import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/create_screen.dart';
import 'screens/events_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/passes_screen.dart';
import 'store.dart';
import 'theme.dart';
import 'widgets/floating_tab_bar.dart';

void main() {
  runApp(const ParipadiApp());
}

/// Paripadi (പരിപാടി — Malayalam for "event" / "program") —
/// Apple-inspired event management prototype for festivals and
/// games/sports events.
class ParipadiApp extends StatefulWidget {
  const ParipadiApp({super.key});

  @override
  State<ParipadiApp> createState() => _ParipadiAppState();
}

class _ParipadiAppState extends State<ParipadiApp> {
  final EventStore _store = EventStore();
  int _tabIndex = 0;
  bool _isDark = false;

  void _refresh() => setState(() {});

  void _goToTab(int index) => setState(() => _tabIndex = index);

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    // Hide the floating nav while the keyboard is open: the old code
    // added viewInsets.bottom to the nav offset, so the nav rode up
    // on top of the keyboard.
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return CupertinoApp(
      title: 'Paripadi',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        primaryColor: AppColors.blue,
        scaffoldBackgroundColor:
            _isDark ? CupertinoColors.black : AppColors.lightBackground,
        barBackgroundColor: _isDark
            ? AppColors.darkSurface.withValues(alpha: 0.85)
            : CupertinoColors.white.withValues(alpha: 0.8),
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.inter(
            fontSize: 17,
            color: CupertinoColors.label,
          ),
          navTitleTextStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
          navLargeTitleTextStyle: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: CupertinoColors.label,
          ),
          actionTextStyle: GoogleFonts.inter(
            fontSize: 17,
            color: AppColors.blue,
          ),
        ),
      ),
      // Custom tab scaffold (v1.0.1): the tabs live in an IndexedStack of
      // CupertinoTabViews (each keeps its own Navigator for sheets), and
      // the floating pill nav hovers above the content — 16px clear of
      // the edges and of the safe area / keyboard. Sheets use the root
      // navigator (showCupertinoModalPopup), so they still cover the nav.
      home: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: Stack(
          children: [
            IndexedStack(
              index: _tabIndex,
              children: [
                CupertinoTabView(
                  builder: (_) => OverviewScreen(
                    store: _store,
                    isDark: _isDark,
                    onToggleTheme: _toggleTheme,
                    onRefresh: _refresh,
                    onGoToTab: _goToTab,
                  ),
                ),
                CupertinoTabView(
                  builder: (_) => EventsScreen(
                    store: _store,
                    isDark: _isDark,
                    onToggleTheme: _toggleTheme,
                    onRefresh: _refresh,
                    onGoToTab: _goToTab,
                    onGoToCreate: () => _goToTab(3),
                  ),
                ),
                CupertinoTabView(
                  builder: (_) => PassesScreen(
                    store: _store,
                    isDark: _isDark,
                    onToggleTheme: _toggleTheme,
                    onRefresh: _refresh,
                  ),
                ),
                CupertinoTabView(
                  builder: (_) => CreateScreen(
                    store: _store,
                    isDark: _isDark,
                    onToggleTheme: _toggleTheme,
                    onRefresh: _refresh,
                    onGoToTab: _goToTab,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.of(context).padding.bottom,
              child: AnimatedOpacity(
                opacity: keyboardOpen ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: keyboardOpen,
                  child: FloatingTabBar(
                    currentIndex: _tabIndex,
                    onTap: _goToTab,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
