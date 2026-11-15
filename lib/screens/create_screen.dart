import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets/toast.dart';

/// Tab 4 — Create New Event. Category segmented picker unlocks tailored
/// settings: Sports covers tournaments, matches and track events
/// (fixtures, live scores, standings); Social covers RSVP, catering
/// and bill splitting.
class CreateScreen extends StatefulWidget {
  const CreateScreen({
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
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  EventType _category = EventType.sports;
  final _titleController = TextEditingController();
  final _dateController =
      TextEditingController(text: 'Dec 12, 2026 • 10:00 AM');
  final _locationController = TextEditingController();
  final _contributionController =
      TextEditingController(text: '₹1,500');

  String _format = 'Knockout Bracket';
  String _teamMode = '4 Houses (Red/Blue/Green/Yellow)';
  bool _rsvpEnabled = true;
  bool _foodEnabled = true;
  bool _splitEnabled = true;
  String? _error;

  static const List<String> _formats = [
    'Knockout Bracket',
    'League + Playoffs',
    'Track & Field Heats',
  ];
  static const List<String> _teamModes = [
    '4 Houses (Red/Blue/Green/Yellow)',
    'Open Club Teams',
    'Individual Athletes',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _contributionController.dispose();
    super.dispose();
  }

  void _launch() {
    final title = _titleController.text.trim();
    final date = _dateController.text.trim();
    final location = _locationController.text.trim();
    if (title.isEmpty || date.isEmpty || location.isEmpty) {
      setState(
        () => _error = 'Please fill in the title, date and venue.',
      );
      return;
    }
    widget.store.addEvent(
      title: title,
      date: date,
      location: location,
      type: _category,
    );
    widget.onRefresh();
    showIosToast(context, 'Created "$title"');
    widget.onGoToTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final isSports = _category == EventType.sports;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground
          .resolveFrom(context),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              'Create',
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
              child: IosCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create New Event',
                      style: AppText.title(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a category to unlock tailored management tools',
                      style: AppText.subheadline(
                        context,
                        color: CupertinoColors.secondaryLabel
                            .resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CupertinoSlidingSegmentedControl<EventType>(
                      groupValue: _category,
                      backgroundColor: CupertinoColors.secondarySystemFill
                          .resolveFrom(context),
                      thumbColor: CupertinoColors
                          .secondarySystemGroupedBackground
                          .resolveFrom(context),
                      children: {
                        EventType.sports: _segmentLabel(
                          CupertinoIcons.sportscourt,
                          'Sports / Athletics',
                          AppColors.orange,
                        ),
                        EventType.social: _segmentLabel(
                          CupertinoIcons.music_note,
                          'Get-Together / Social',
                          AppColors.purple,
                        ),
                      },
                      onValueChanged: (value) {
                        if (value != null) {
                          setState(() => _category = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _field(
                      label: 'Event Title',
                      placeholder:
                          'e.g., Inter-College Football Cup or Family Reunion',
                      controller: _titleController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            label: 'Date & Time',
                            placeholder: 'Dec 12, 2026 • 10:00 AM',
                            controller: _dateController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            label: 'Venue / Location',
                            placeholder: 'e.g., Jawaharlal Nehru Stadium',
                            controller: _locationController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isSports) _sportsSettings() else _socialSettings(),
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
                      onPressed: _launch,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Launch Event Workspace',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentLabel(IconData icon, String label, Color color) {
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

  Widget _field({
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
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground
                .resolveFrom(context),
            borderRadius: BorderRadius.circular(14),
          ),
          style: GoogleFonts.inter(fontSize: 15),
          placeholderStyle: GoogleFonts.inter(
            fontSize: 14,
            color: CupertinoColors.placeholderText.resolveFrom(context),
          ),
        ),
      ],
    );
  }

  /// Sports settings — tournaments, matches and track events.
  Widget _sportsSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 14,
                color: AppColors.orange,
              ),
              const SizedBox(width: 6),
              Text(
                'Sports & Tournament Settings',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Covers tournaments, matches & track events — fixtures, live scores and standings are set up automatically.',
            style: AppText.caption(
              context,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 12),
          _optionList(
            label: 'Tournament Format',
            options: _formats,
            selected: _format,
            onSelected: (v) => setState(() => _format = v),
          ),
          const SizedBox(height: 12),
          _optionList(
            label: 'Team / House Mode',
            options: _teamModes,
            selected: _teamMode,
            onSelected: (v) => setState(() => _teamMode = v),
          ),
        ],
      ),
    );
  }

  /// iOS selection list: rows with a checkmark on the selected option.
  Widget _optionList({
    required String label,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground
                .resolveFrom(context),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  onPressed: () => onSelected(options[i]),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          options[i],
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      ),
                      if (options[i] == selected)
                        const Icon(
                          CupertinoIcons.checkmark,
                          size: 16,
                          color: AppColors.blue,
                        ),
                    ],
                  ),
                ),
                if (i != options.length - 1)
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 14),
                    color:
                        CupertinoColors.separator.resolveFrom(context),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Social settings — contribution + feature toggles (iOS switches).
  Widget _socialSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.placemark_fill,
                size: 14,
                color: AppColors.purple,
              ),
              const SizedBox(width: 6),
              Text(
                'Get-Together & Catering Settings',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _field(
            label: 'Per-Person Contribution',
            placeholder: '₹1,500',
            controller: _contributionController,
          ),
          const SizedBox(height: 12),
          _toggleRow(
            'RSVP Tracking',
            'Going / Maybe / Declined with headcount',
            _rsvpEnabled,
            (v) => setState(() => _rsvpEnabled = v),
          ),
          _toggleRow(
            'Food Preferences',
            'Veg / Non-Veg catering headcount',
            _foodEnabled,
            (v) => setState(() => _foodEnabled = v),
          ),
          _toggleRow(
            'Bill Split',
            'Smart expense splitter per person',
            _splitEnabled,
            (v) => setState(() => _splitEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.subheadline(context)),
                Text(
                  subtitle,
                  style: AppText.caption(
                    context,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
