import 'logic.dart';
import 'models.dart';

/// In-memory store for the Paripadi prototype. No backend, no persistence —
/// everything here mirrors the sample data in the HTML prototype.
class EventStore {
  EventStore() {
    events = [
      EventItem(
        id: 'evt-sports',
        title: 'Annual Athletics & Football 2026',
        type: EventType.sports,
        subtitle: 'Sports & Athletics Mode',
        date: 'Nov 15, 2026 • 09:00 AM',
        location: 'Main Turf & Track Arena',
        badge: 'Live Tournament',
      ),
      EventItem(
        id: 'evt-social',
        title: 'Batch 2020 Grand Reunion & Dinner',
        type: EventType.social,
        subtitle: 'Get-Together & Social Mode',
        date: 'Nov 28, 2026 • 07:00 PM',
        location: 'Grand Hyatt Ballroom',
        badge: '42 RSVPs',
      ),
    ];
    participants = [
      Participant(
        id: 'P-101',
        name: 'Rahul Menon',
        meta: 'Red House',
        role: 'Football Captain',
        food: 'Non-Veg',
        paid: true,
        checkedIn: true,
      ),
      Participant(
        id: 'P-102',
        name: 'Sneha Nair',
        meta: 'Blue House',
        role: '100m Sprinter',
        food: 'Veg',
        paid: true,
        checkedIn: true,
      ),
      Participant(
        id: 'P-103',
        name: 'Abinav Das',
        meta: 'Green House',
        role: 'Badminton',
        food: 'Non-Veg',
        paid: false,
        checkedIn: true,
      ),
      Participant(
        id: 'P-104',
        name: 'Meera Krishnan',
        meta: 'Red House',
        role: 'Relay Team',
        food: 'Veg',
        paid: true,
        checkedIn: false,
      ),
      Participant(
        id: 'P-105',
        name: 'Faisal Rahman',
        meta: 'Blue House',
        role: 'Goalkeeper',
        food: 'Non-Veg',
        paid: false,
        checkedIn: true,
      ),
      Participant(
        id: 'P-106',
        name: 'Diya Varma',
        meta: 'Yellow House',
        role: 'Guest (+1)',
        food: 'Veg',
        paid: true,
        checkedIn: false,
      ),
    ];
  }

  late List<EventItem> events;
  late List<Participant> participants;

  String activeEventId = 'evt-sports';

  /// Live football final score: Red House (A) vs Blue House (B).
  int scoreA = 2;
  int scoreB = 1;
  String matchClock = "74:12'";

  EventItem get activeEvent =>
      events.firstWhere((e) => e.id == activeEventId, orElse: () => events.first);

  int get checkedInCount => participants.where((p) => p.checkedIn).length;
  int get checkInPercent => checkInRate(checkedInCount, participants.length);

  /// Live / Scheduled count shown on the third KPI card.
  int get liveScheduledCount => 3;

  static const List<HouseStanding> baseStandings = [
    HouseStanding(
      rank: 1,
      name: 'Red House',
      team: 'Phoenix',
      gold: 6,
      silver: 3,
      points: 145,
    ),
    HouseStanding(
      rank: 2,
      name: 'Blue House',
      team: 'Titans',
      gold: 4,
      silver: 5,
      points: 128,
    ),
    HouseStanding(
      rank: 3,
      name: 'Green House',
      team: 'Vipers',
      gold: 3,
      silver: 2,
      points: 96,
    ),
  ];

  /// Standings with live points: Red 143 + scoreA, Blue 127 + scoreB,
  /// then sorted by points (mirrors the prototype's updateScore).
  List<HouseStanding> get standings {
    final live = [
      baseStandings[0].copyWithPoints(liveHousePoints(143, scoreA)),
      baseStandings[1].copyWithPoints(liveHousePoints(127, scoreB)),
      baseStandings[2],
    ];
    return sortStandings(live);
  }

  static const List<Fixture> fixtures = [
    Fixture(
      title: "100m Sprint — Men's Heats",
      detail: 'Main Track • 03:30 PM',
      status: 'Next Up',
      isCompleted: false,
    ),
    Fixture(
      title: 'Badminton Mixed Doubles',
      detail: 'Green House def. Yellow House (21-18)',
      status: 'Completed',
      isCompleted: true,
    ),
  ];

  static const RsvpStats rsvp = RsvpStats(
    confirmed: 42,
    goingPercent: 75,
    maybePercent: 15,
    declinedPercent: 10,
    vegPlates: 16,
    nonVegPlates: 26,
    pollTitle: 'Live Poll: After-Dinner Activity',
    pollDetail: 'Karaoke Night leading with 68% votes',
  );

  static const double expenseTotal = 63000;
  static const int expensePeople = 42;
  static const String expenseLabel = 'Venue + Dinner Buffet + DJ';

  double get expensePerPerson => perPersonShare(expenseTotal, expensePeople);

  void selectEvent(String id) {
    activeEventId = id;
  }

  void updateScore({required bool teamA, required int delta}) {
    if (teamA) {
      scoreA = (scoreA + delta).clamp(0, 99);
    } else {
      scoreB = (scoreB + delta).clamp(0, 99);
    }
  }

  void toggleCheckIn(String participantId) {
    participants = participants
        .map(
          (p) => p.id == participantId
              ? p.copyWith(checkedIn: !p.checkedIn)
              : p,
        )
        .toList();
  }

  void togglePaid(String participantId) {
    participants = participants
        .map(
          (p) => p.id == participantId ? p.copyWith(paid: !p.paid) : p,
        )
        .toList();
  }

  Participant addParticipant({
    required String name,
    required String meta,
    required String role,
  }) {
    final food = meta.toLowerCase().contains('veg') &&
            !meta.toLowerCase().contains('non')
        ? 'Veg'
        : 'Non-Veg';
    final participant = Participant(
      id: nextParticipantId(participants.length),
      name: name,
      meta: meta,
      role: role.isEmpty ? 'Participant' : role,
      food: food,
      paid: false,
      checkedIn: false,
    );
    participants = [participant, ...participants];
    return participant;
  }

  void addEvent({
    required String title,
    required String date,
    required String location,
    required EventType type,
  }) {
    events = [
      ...events,
      EventItem(
        id: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        type: type,
        subtitle: type == EventType.sports
            ? 'Sports & Athletics Mode'
            : 'Get-Together & Social Mode',
        date: date,
        location: location,
        badge: 'Just Created',
      ),
    ];
    activeEventId = events.last.id;
  }
}

extension on HouseStanding {
  HouseStanding copyWithPoints(int points) => HouseStanding(
        rank: rank,
        name: name,
        team: team,
        gold: gold,
        silver: silver,
        points: points,
      );
}
