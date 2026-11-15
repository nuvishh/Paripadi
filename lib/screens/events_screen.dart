import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../store.dart';
import '../theme.dart';

/// Tab 2 — Your Managed Events. Filter segmented control:
/// All / Live (checked-in, happening now) / Upcoming (pending).
class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    required this.store,
    required this.isDark,
    required this.onToggleTheme,
    required this.onRefresh,
    required this.onGoToTab,
    required this.onGoToCreate,
  });

  final EventStore store;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onRefresh;
  final void Function(int tab) onGoToTab;
  final VoidCallback onGoToCreate;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _filter = 0; // 0 All, 1 Live, 2 Upcoming

  List<EventItem> get _filtered {
    switch (_filter) {
      case 1:
        return widget.store.events.where((e) => e.isLive).toList();
      case 2:
        return widget.store.events.where((e) => !e.isLive).toList();
      default:
        return widget.store.events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground
          .resolveFrom(context),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              'Events',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
              onPressed: widget.onToggleTheme,
              child: Icon(
                widget.isDark
                    ? CupertinoIcons.sun_max_fill
                    : CupertinoIcons.moon_fill,
                size: 20,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your Managed Events',
                          style: AppText.title(context)),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(32, 32),
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(999),
                        onPressed: widget.onGoToCreate,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.plus,
                                size: 14, color: CupertinoColors.white),
                            const SizedBox(width: 4),
                            Text(
                              'New Event',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _filter,
                    backgroundColor: CupertinoColors.secondarySystemFill
                        .resolveFrom(context),
                    thumbColor:
                        CupertinoColors.secondarySystemGroupedBackground
                            .resolveFrom(context),
                    children: {
                      0: _segmentLabel('All'),
                      1: _segmentLabel('Live'),
                      2: _segmentLabel('Upcoming'),
                    },
                    onValueChanged: (value) {
                      if (value != null) setState(() => _filter = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_filtered.isEmpty)
                    IosCard(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No events in this view yet.',
                            style: AppText.subheadline(
                              context,
                              color: CupertinoColors.secondaryLabel
                                  .resolveFrom(context),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    ..._filtered.map((e) => _eventCard(context, e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _eventCard(BuildContext context, EventItem event) {
    final accent = event.isSports ? AppColors.orange : AppColors.purple;
    return IosCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PillBadge(
                label: event.isSports
                    ? 'Sports & Athletics'
                    : 'Social / Get-Together',
                color: accent,
              ),
              Text(
                event.badge,
                style: AppText.caption(
                  context,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(event.title, style: AppText.headline(context)),
          const SizedBox(height: 8),
          _metaRow(
            context,
            CupertinoIcons.placemark_fill,
            event.location,
          ),
          const SizedBox(height: 4),
          _metaRow(context, CupertinoIcons.clock_fill, event.date),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: CupertinoColors.secondarySystemFill.resolveFrom(context),
              onPressed: () {
                widget.store.selectEvent(event.id);
                widget.onRefresh();
                widget.onGoToTab(0);
              },
              child: Text(
                'Open Event Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppText.subheadline(
              context,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
      ],
    );
  }
}
