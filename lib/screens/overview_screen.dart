import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets/toast.dart';

/// Tab 1 — Bento overview. Mirrors the prototype's overview: user chip,
/// live Dynamic Island pill, event switcher, KPI cards, and the
/// sports / social dashboard sections that swap with the active event.
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.store,
    required this.isDark,
    required this.onToggleTheme,
    required this.onRefresh,
    required this.onGoToTab,
  });

  final EventStore store;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onRefresh;
  final void Function(int tab) onGoToTab;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground
          .resolveFrom(context),
      child: CustomScrollView(
        slivers: [
          // Direction B hero header: gradient band with the title and
          // tagline in white (both themes); theme toggle top-right.
          SliverToBoxAdapter(
            child: GradientHero(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 20,
                  right: 20,
                  bottom: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Paripadi',
                            style: GoogleFonts.inter(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onToggleTheme,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: CupertinoColors.white
                                  .withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isDark
                                  ? CupertinoIcons.sun_max_fill
                                  : CupertinoIcons.moon_fill,
                              size: 18,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'പരിപാടി · Events, festivals & games',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color:
                            CupertinoColors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 116),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userChip(context),
                  const SizedBox(height: 14),
                  _livePill(context),
                  const SizedBox(height: 18),
                  _eventHeader(context),
                  const SizedBox(height: 16),
                  _kpiGrid(context),
                  if (store.activeEvent.isSports) ...[
                    const SizedBox(height: 16),
                    _liveMatchCard(context),
                    const SizedBox(height: 16),
                    _standingsCard(context),
                  ] else ...[
                    const SizedBox(height: 16),
                    _rsvpCard(context),
                    const SizedBox(height: 16),
                    _expenseCard(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userChip(BuildContext context) {
    return IosCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'AK',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Arjun Krishna', style: AppText.headline(context)),
                Text(
                  'Lead Organizer • Admin',
                  style: AppText.footnote(
                    context,
                    color: AppColors.strongSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const PillBadge(label: 'Active Workspace', color: AppColors.blue),
        ],
      ),
    );
  }

  Widget _livePill(BuildContext context) {
    return GestureDetector(
      onTap: () {
        store.selectEvent('evt-sports');
        onRefresh();
        showIosToast(context, 'Switched to Annual Athletics & Football 2026');
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: CupertinoColors.white.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: CupertinoColors.white.withValues(alpha: 0.15),
            ),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: CupertinoColors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'Football Final: ',
                      style: GoogleFonts.inter(
                        color: CupertinoColors.white
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    const TextSpan(
                      text: 'Red House ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '${store.scoreA} - ${store.scoreB}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const TextSpan(
                      text: ' Blue House',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventHeader(BuildContext context) {
    final event = store.activeEvent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.subtitle.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.readable(AppColors.blue, context),
          ),
        ),
        const SizedBox(height: 4),
        Text(event.title, style: AppText.title(context)),
        const SizedBox(height: 12),
        CupertinoSlidingSegmentedControl<int>(
          groupValue: event.isSports ? 0 : 1,
          backgroundColor: CupertinoColors.secondarySystemFill
              .resolveFrom(context),
          thumbColor: CupertinoColors.secondarySystemGroupedBackground
              .resolveFrom(context),
          children: {
            0: _segmentLabel(context, CupertinoIcons.sportscourt, 'Sports Fest',
                AppColors.orange),
            1: _segmentLabel(context, CupertinoIcons.music_note,
                'Batch Reunion', AppColors.purple),
          },
          onValueChanged: (value) {
            if (value == null) return;
            store.selectEvent(value == 0 ? 'evt-sports' : 'evt-social');
            onRefresh();
          },
        ),
      ],
    );
  }

  Widget _segmentLabel(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _kpiCard(
          context,
          icon: CupertinoIcons.calendar,
          color: AppColors.blue,
          value: '${store.events.length}',
          label: 'Total Events',
          badge: const PillBadge(label: 'Active', color: AppColors.green),
        ),
        _kpiCard(
          context,
          icon: CupertinoIcons.person_2_fill,
          color: AppColors.green,
          value: '${store.participants.length}',
          label: 'Participants',
          badge: Text(
            '${store.checkInPercent}% In',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.strongSecondary(context),
            ),
          ),
        ),
        _kpiCard(
          context,
          icon: CupertinoIcons.flame_fill,
          color: AppColors.orange,
          value: '${store.liveScheduledCount}',
          label: 'Live / Scheduled',
          badge:
              const PillBadge(label: 'Real-time', color: AppColors.orange),
        ),
        _kpiCard(
          context,
          icon: CupertinoIcons.checkmark_circle_fill,
          color: AppColors.purple,
          value: '${store.checkedInCount}',
          label: 'Checked-In Passes',
          badge: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(20, 20),
            onPressed: () => onGoToTab(2),
            child: Text(
              'Manage',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kpiCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    required Widget badge,
  }) {
    return IosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconTile(icon: icon, color: color),
              badge,
            ],
          ),
          const Spacer(),
          Text(value, style: AppText.kpiValue(context)),
          Text(
            label,
            style: AppText.footnote(
              context,
              color: AppColors.strongSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveMatchCard(BuildContext context) {
    // Dark gradient card in BOTH themes — every text inside is white
    // or onDarkMuted, never a theme label color.
    return DarkGradientCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PillBadge(
                label: '● Live Match Control',
                color: AppColors.red,
              ),
              Text(
                'Finals • Turf Ground A',
                style: AppText.footnote(
                  context,
                  color: AppColors.onDarkMuted,
                ),
              ),
              Text(
                store.matchClock,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onDarkMuted,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: CupertinoColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _teamScore(
                    context,
                    initials: 'RH',
                    gradient: const [
                      Color(0xFFEF4444),
                      Color(0xFFEA580C),
                    ],
                    name: 'Red House',
                    sub: 'Phoenix XI',
                    score: store.scoreA,
                    onMinus: () {
                      store.updateScore(teamA: true, delta: -1);
                      onRefresh();
                    },
                    onPlus: () {
                      store.updateScore(teamA: true, delta: 1);
                      onRefresh();
                    },
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'VS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: AppColors.onDarkMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap + / - to update',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Expanded(
                  child: _teamScore(
                    context,
                    initials: 'BH',
                    gradient: const [
                      Color(0xFF3B82F6),
                      Color(0xFF4F46E5),
                    ],
                    name: 'Blue House',
                    sub: 'Titans FC',
                    score: store.scoreB,
                    onMinus: () {
                      store.updateScore(teamA: false, delta: -1);
                      onRefresh();
                    },
                    onPlus: () {
                      store.updateScore(teamA: false, delta: 1);
                      onRefresh();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SectionLabel(
            'Match & Track Fixtures',
            color: AppColors.onDarkMuted,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Knockout Stage',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.linkOnDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...EventStore.fixtures.map((f) => _fixtureRow(context, f)),
        ],
      ),
    );
  }

  Widget _teamScore(
    BuildContext context, {
    required String initials,
    required List<Color> gradient,
    required String name,
    required String sub,
    required int score,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: AppText.headline(context, color: AppColors.onDark),
        ),
        Text(
          sub,
          style: AppText.caption(
            context,
            color: AppColors.onDarkMuted,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: CupertinoColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roundStepButton(context, '-', onMinus),
              SizedBox(
                width: 28,
                child: Text(
                  '$score',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onDark,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              _roundStepButton(context, '+', onPlus, filled: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roundStepButton(
    BuildContext context,
    String label,
    VoidCallback onPressed, {
    bool filled = false,
  }) {
    // Inside the dark match card: unfilled steppers are translucent
    // white, filled is blue — white text in both themes.
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled
              ? AppColors.blue
              : CupertinoColors.white.withValues(alpha: 0.16),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }

  Widget _fixtureRow(BuildContext context, Fixture fixture) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconTile(
            icon: fixture.isCompleted
                ? CupertinoIcons.rosette
                : CupertinoIcons.timer,
            color: fixture.isCompleted ? AppColors.green : AppColors.orange,
            size: 32,
            iconSize: 15,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fixture.title,
                  style: AppText.subheadline(
                    context,
                    color: AppColors.onDark,
                  ),
                ),
                Text(
                  fixture.detail,
                  style: AppText.caption(
                    context,
                    color: AppColors.onDarkMuted,
                  ),
                ),
              ],
            ),
          ),
          PillBadge(
            label: fixture.status,
            color: fixture.isCompleted ? AppColors.green : AppColors.orange,
          ),
        ],
      ),
    );
  }

  Widget _standingsCard(BuildContext context) {
    final standings = store.standings;
    return IosCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Championship Standings',
                      style: AppText.headline(context)),
                  Text(
                    'Overall House Points Table',
                    style: AppText.footnote(
                      context,
                      color:
                          AppColors.strongSecondary(context),
                    ),
                  ),
                ],
              ),
              const IconTile(
                icon: CupertinoIcons.star_fill,
                color: AppColors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...standings.map((s) => _standingRow(context, s)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: CupertinoColors.secondarySystemFill.resolveFrom(context),
              onPressed: () => onGoToTab(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.barcode, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    'View Athlete QR Passes',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _standingRow(BuildContext context, HouseStanding s) {
    final isFirst = s.rank == 1;
    final rankColor = s.rank == 1
        ? const Color(0xFFF59E0B)
        : s.rank == 2
            ? CupertinoColors.systemGrey
            : const Color(0xFFB45309);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isFirst
            ? AppColors.orange.withValues(alpha: 0.08)
            : CupertinoColors.secondarySystemGroupedBackground
                .resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        border: isFirst
            ? Border.all(color: AppColors.orange.withValues(alpha: 0.25))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rankColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${s.rank}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.label, style: AppText.headline(context)),
                Text(
                  s.medals,
                  style: AppText.caption(
                    context,
                    color: AppColors.strongSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${s.points} pts',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isFirst ? AppColors.orange : null,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rsvpCard(BuildContext context) {
    final rsvp = EventStore.rsvp;
    return IosCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RSVP & Catering Tracker',
                      style: AppText.headline(context)),
                  Text(
                    'Grand Hyatt Ballroom • Nov 28, 7:00 PM',
                    style: AppText.footnote(
                      context,
                      color:
                          AppColors.strongSecondary(context),
                    ),
                  ),
                ],
              ),
              PillBadge(
                label: '${rsvp.confirmed} Confirmed',
                color: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Going (${rsvp.goingPercent}%)',
                  style: _rsvpLabelStyle(AppColors.green)),
              Text('Maybe (${rsvp.maybePercent}%)',
                  style: _rsvpLabelStyle(AppColors.orange)),
              Text('Declined (${rsvp.declinedPercent}%)',
                  style: _rsvpLabelStyle(CupertinoColors.systemGrey)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Row(
              children: [
                Expanded(
                  flex: rsvp.goingPercent,
                  child: Container(height: 12, color: AppColors.green),
                ),
                Expanded(
                  flex: rsvp.maybePercent,
                  child: Container(height: 12, color: AppColors.orange),
                ),
                Expanded(
                  flex: rsvp.declinedPercent,
                  child: Container(
                    height: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          const SectionLabel('Catering Headcount'),
          Row(
            children: [
              Expanded(
                child: _foodBox(
                  context,
                  label: 'Pure Veg',
                  plates: rsvp.vegPlates,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _foodBox(
                  context,
                  label: 'Non-Veg',
                  plates: rsvp.nonVegPlates,
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CupertinoColors.secondarySystemGroupedBackground
                  .resolveFrom(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const IconTile(
                  icon: CupertinoIcons.music_note,
                  color: AppColors.purple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rsvp.pollTitle,
                          style: AppText.subheadline(context)),
                      Text(
                        rsvp.pollDetail,
                        style: AppText.caption(
                          context,
                          color: AppColors.strongSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Active',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _rsvpLabelStyle(Color color) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      );

  Widget _foodBox(
    BuildContext context, {
    required String label,
    required int plates,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              children: [
                TextSpan(text: '$plates '),
                TextSpan(
                  text: 'plates',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.strongSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseCard(BuildContext context) {
    final shown = store.participants.take(4).toList();
    return IosCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smart Expense Splitter',
                      style: AppText.headline(context)),
                  Text(
                    EventStore.expenseLabel,
                    style: AppText.footnote(
                      context,
                      color:
                          AppColors.strongSecondary(context),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${EventStore.expenseTotal.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    '₹${store.expensePerPerson.toInt()} / person',
                    style: AppText.caption(
                      context,
                      color:
                          AppColors.strongSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...shown.map((p) => _expenseRow(context, p)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () => onGoToTab(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.creditcard, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    'Manage Guest List & Entry Passes',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseRow(BuildContext context, Participant p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground
            .resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.purple,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              p.initials,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: AppText.subheadline(context)),
                Text(
                  '${p.food} • ₹1,500 share',
                  style: AppText.caption(
                    context,
                    color: AppColors.strongSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: p.paid,
            activeTrackColor: AppColors.green,
            onChanged: (_) {
              store.togglePaid(p.id);
              onRefresh();
              showIosToast(
                context,
                '${p.name}: ${!p.paid ? 'Marked as Paid' : 'Marked Pending'}',
              );
            },
          ),
        ],
      ),
    );
  }
}
