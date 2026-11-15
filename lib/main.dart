import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/create_screen.dart';
import 'screens/events_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/passes_screen.dart';
import 'store.dart';
import 'theme.dart';

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
  final CupertinoTabController _tabController = CupertinoTabController();
  bool _isDark = false;

  void _refresh() => setState(() {});

  void _goToTab(int index) {
    _tabController.index = index;
    setState(() {});
  }

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          textStyle: GoogleFonts.inter(fontSize: 17),
          navTitleTextStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          navLargeTitleTextStyle: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          tabLabelTextStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          actionTextStyle: GoogleFonts.inter(
            fontSize: 17,
            color: AppColors.blue,
          ),
        ),
      ),
      home: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          activeColor: AppColors.blue,
          inactiveColor: CupertinoColors.systemGrey,
          backgroundColor: _isDark
              ? AppColors.darkSurface.withValues(alpha: 0.9)
              : CupertinoColors.white.withValues(alpha: 0.85),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Bento',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.ticket),
              label: 'Passes',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus_circle),
              label: 'Create',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (_) => OverviewScreen(
                  store: _store,
                  isDark: _isDark,
                  onToggleTheme: _toggleTheme,
                  onRefresh: _refresh,
                  onGoToTab: _goToTab,
                ),
              );
            case 1:
              return CupertinoTabView(
                builder: (_) => EventsScreen(
                  store: _store,
                  isDark: _isDark,
                  onToggleTheme: _toggleTheme,
                  onRefresh: _refresh,
                  onGoToTab: _goToTab,
                  onGoToCreate: () => _goToTab(3),
                ),
              );
            case 2:
              return CupertinoTabView(
                builder: (_) => PassesScreen(
                  store: _store,
                  isDark: _isDark,
                  onToggleTheme: _toggleTheme,
                  onRefresh: _refresh,
                ),
              );
            default:
              return CupertinoTabView(
                builder: (_) => CreateScreen(
                  store: _store,
                  isDark: _isDark,
                  onToggleTheme: _toggleTheme,
                  onRefresh: _refresh,
                  onGoToTab: _goToTab,
                ),
              );
          }
        },
      ),
    );
  }
}
