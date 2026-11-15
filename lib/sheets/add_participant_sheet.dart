import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../store.dart';
import '../theme.dart';

/// iOS sheet form for adding a participant and generating their QR pass.
/// Returns the created [Participant], or null if cancelled.
Future<Participant?> showAddParticipantSheet(
  BuildContext context,
  EventStore store,
) {
  return showCupertinoModalPopup<Participant?>(
    context: context,
    builder: (sheetContext) => _AddParticipantSheet(store: store),
  );
}

class _AddParticipantSheet extends StatefulWidget {
  const _AddParticipantSheet({required this.store});

  final EventStore store;

  @override
  State<_AddParticipantSheet> createState() => _AddParticipantSheetState();
}

class _AddParticipantSheetState extends State<_AddParticipantSheet> {
  final _nameController = TextEditingController();
  final _metaController = TextEditingController();
  final _roleController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _metaController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final meta = _metaController.text.trim();
    if (name.isEmpty || meta.isEmpty) {
      setState(() => _error = 'Name and House / Team are required.');
      return;
    }
    final participant = widget.store.addParticipant(
      name: name,
      meta: meta,
      role: _roleController.text.trim(),
    );
    Navigator.of(context).pop(participant);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : CupertinoColors.white,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey3.resolveFrom(context),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Participant', style: AppText.title(context)),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(28, 28),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      size: 26,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'A QR pass is generated instantly for the new participant.',
                style: AppText.subheadline(
                  context,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              const SizedBox(height: 20),
              _field(
                context,
                label: 'Participant Name',
                placeholder: 'e.g. Rahul Menon',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              _field(
                context,
                label: 'House / Team (or Veg / Non-Veg)',
                placeholder: 'e.g. Red House',
                controller: _metaController,
              ),
              const SizedBox(height: 12),
              _field(
                context,
                label: 'Role',
                placeholder: 'e.g. Striker / Guest',
                controller: _roleController,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.red,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: _submit,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String placeholder,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.footnote(context)),
        const SizedBox(height: 6),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground
                .resolveFrom(context),
            borderRadius: BorderRadius.circular(14),
          ),
          style: GoogleFonts.inter(fontSize: 15),
          placeholderStyle: GoogleFonts.inter(
            fontSize: 15,
            color: CupertinoColors.placeholderText.resolveFrom(context),
          ),
        ),
      ],
    );
  }
}
