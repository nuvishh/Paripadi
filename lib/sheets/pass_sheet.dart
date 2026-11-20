import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets/qr_matrix.dart';
import '../widgets/toast.dart';

/// Apple Wallet-style QR pass, presented as an iOS bottom sheet.
Future<void> showPassSheet(
  BuildContext context,
  EventStore store,
  Participant participant, {
  required VoidCallback onChanged,
}) {
  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) => _PassSheet(
      store: store,
      participantId: participant.id,
      onChanged: onChanged,
    ),
  );
}

class _PassSheet extends StatefulWidget {
  const _PassSheet({
    required this.store,
    required this.participantId,
    required this.onChanged,
  });

  final EventStore store;
  final String participantId;
  final VoidCallback onChanged;

  @override
  State<_PassSheet> createState() => _PassSheetState();
}

class _PassSheetState extends State<_PassSheet> {
  Participant get participant => widget.store.participants
      .firstWhere((p) => p.id == widget.participantId);

  EventItem get event => widget.store.activeEvent;

  @override
  Widget build(BuildContext context) {
    final isDark =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    final p = participant;
    final headerGradient = event.isSports
        ? const [AppColors.blue, AppColors.lightBlue]
        : const [AppColors.purple, AppColors.pink];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.3),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle.
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey3.resolveFrom(context),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              // Wallet header.
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: headerGradient),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PARIPADI PASS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: CupertinoColors.white
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(28, 28),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: CupertinoColors.black
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.xmark,
                              size: 14,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: CupertinoColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.passId,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: CupertinoColors.white
                            .withValues(alpha: 0.8),
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              // Ticket cutout divider.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _CutoutDot(isDark: isDark),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: DashedLine(),
                      ),
                    ),
                    _CutoutDot(isDark: isDark),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    Text(
                      p.name,
                      style: AppText.title(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p.meta} • ${p.role}',
                      style: AppText.subheadline(
                        context,
                        color: AppColors.strongSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    QrMatrix(seed: p.id + p.name, size: 168),
                    const SizedBox(height: 20),
                    // Check-in button.
                    SizedBox(
                      width: double.infinity,
                      child: p.checkedIn
                          ? CupertinoButton(
                              color: AppColors.green.withValues(alpha: 0.15),
                              onPressed: _toggleCheckIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.checkmark_circle_fill,
                                    size: 16,
                                    color: AppColors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Checked In at Venue (Tap to Undo)',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CupertinoButton.filled(
                              onPressed: _toggleCheckIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.barcode,
                                    size: 16,
                                    color: CupertinoColors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Verify & Check-In Guest',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    // Payment status toggle (iOS switch).
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground
                            .resolveFrom(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const IconTile(
                            icon: CupertinoIcons.creditcard,
                            color: AppColors.purple,
                            size: 32,
                            iconSize: 15,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Status',
                                  style: AppText.headline(context),
                                ),
                                Text(
                                  p.paid
                                      ? 'Paid • ₹1,500 share'
                                      : 'Payment Pending • ₹1,500 share',
                                  style: AppText.footnote(
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
                            onChanged: (_) => _togglePaid(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleCheckIn() {
    setState(() => widget.store.toggleCheckIn(participant.id));
    widget.onChanged();
    showIosToast(
      context,
      participant.checkedIn
          ? '${participant.name} checked in!'
          : 'Check-in reverted for ${participant.name}',
    );
  }

  void _togglePaid() {
    setState(() => widget.store.togglePaid(participant.id));
    widget.onChanged();
    showIosToast(
      context,
      '${participant.name}: ${participant.paid ? 'Marked as Paid' : 'Marked Pending'}',
    );
  }
}

class _CutoutDot extends StatelessWidget {
  const _CutoutDot({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isDark
            ? CupertinoColors.black
            : AppColors.lightBackground,
        shape: BoxShape.circle,
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
        ),
      ),
    );
  }
}
