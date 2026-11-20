import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../sheets/add_participant_sheet.dart';
import '../sheets/pass_sheet.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets/toast.dart';

/// Tab 3 — Participants & QR Passes. Search, segmented filter
/// (All / Checked-In / Pending), add-participant sheet, and a tap
/// opens the Apple Wallet-style QR pass sheet.
class PassesScreen extends StatefulWidget {
  const PassesScreen({
    super.key,
    required this.store,
    required this.isDark,
    required this.onToggleTheme,
    required this.onRefresh,
  });

  final EventStore store;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onRefresh;

  @override
  State<PassesScreen> createState() => _PassesScreenState();
}

class _PassesScreenState extends State<PassesScreen> {
  int _filter = 0; // 0 All, 1 Checked-In, 2 Pending
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Participant> get _filtered {
    final q = _query.trim().toLowerCase();
    return widget.store.participants.where((p) {
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.meta.toLowerCase().contains(q) ||
          p.id.toLowerCase().contains(q);
      if (!matchesQuery) return false;
      if (_filter == 1) return p.checkedIn;
      if (_filter == 2) return !p.checkedIn;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isSports = widget.store.activeEvent.isSports;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground
          .resolveFrom(context),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              'Passes',
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
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 116),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.store.participants.length} Participants',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.store.checkedInCount} checked in • ${widget.store.participants.length - widget.store.checkedInCount} pending',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: CupertinoColors.white
                                      .withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const IconTile(
                          icon: CupertinoIcons.ticket_fill,
                          color: CupertinoColors.white,
                          size: 44,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: 'Search name, team, or pass ID...',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoSlidingSegmentedControl<int>(
                          groupValue: _filter,
                          backgroundColor: CupertinoColors.secondarySystemFill
                              .resolveFrom(context),
                          thumbColor: CupertinoColors
                              .secondarySystemGroupedBackground
                              .resolveFrom(context),
                          children: {
                            0: _segmentLabel('All'),
                            1: _segmentLabel('Checked-In'),
                            2: _segmentLabel('Pending'),
                          },
                          onValueChanged: (value) {
                            if (value != null) {
                              setState(() => _filter = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _addParticipant,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.person_add, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Add & Generate QR',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SectionLabel('Participants'),
                  if (_filtered.isEmpty)
                    IosCard(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No participants match this view.',
                            style: AppText.subheadline(
                              context,
                              color: AppColors.strongSecondary(context),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    IosCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < _filtered.length; i++) ...[
                            _participantRow(context, _filtered[i], isSports),
                            if (i != _filtered.length - 1)
                              Container(
                                height: 1,
                                margin:
                                    const EdgeInsets.only(left: 64),
                                color: CupertinoColors.separator
                                    .resolveFrom(context),
                              ),
                          ],
                        ],
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

  Widget _segmentLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _addParticipant() async {
    final created = await showAddParticipantSheet(context, widget.store);
    if (created == null) return;
    if (!mounted) return;
    widget.onRefresh();
    showIosToast(context, 'QR Pass generated for ${created.name}');
    await showPassSheet(
      context,
      widget.store,
      created,
      onChanged: widget.onRefresh,
    );
  }

  Widget _participantRow(
    BuildContext context,
    Participant p,
    bool isSports,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => showPassSheet(
        context,
        widget.store,
        p,
        onChanged: () {
          widget.onRefresh();
          setState(() {});
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007AFF), Color(0xFFAF52DE)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                p.initials,
                style: GoogleFonts.inter(
                  fontSize: 14,
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          p.name,
                          style: AppText.headline(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        p.id,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.strongSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSports
                        ? '${p.meta} • ${p.role}'
                        : '${p.food} • ${p.paid ? 'Paid ₹1,500' : 'Payment Pending'}',
                    style: AppText.footnote(
                      context,
                      color:
                          AppColors.strongSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PillBadge(
              label: p.checkedIn ? 'Checked In' : 'Pending',
              color:
                  p.checkedIn ? AppColors.green : AppColors.orange,
            ),
            const SizedBox(width: 6),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ],
        ),
      ),
    );
  }
}
