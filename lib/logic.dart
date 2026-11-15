import 'models.dart';

/// Pure logic for Paripadi — no Flutter imports, fully unit-testable.

/// Per-person share of a total expense, rounded to the nearest rupee.
double perPersonShare(double total, int people) {
  if (people <= 0) return 0;
  return (total / people).roundToDouble();
}

/// Check-in rate as a whole percent (0-100).
int checkInRate(int checkedIn, int total) {
  if (total <= 0) return 0;
  return ((checkedIn / total) * 100).round();
}

/// RSVP split as percentages that always add up to 100.
({int going, int maybe, int declined}) rsvpPercentages({
  required int going,
  required int maybe,
  required int declined,
}) {
  final total = going + maybe + declined;
  if (total <= 0) return (going: 0, maybe: 0, declined: 0);
  final g = (going / total * 100).round();
  final m = (maybe / total * 100).round();
  // Give the remainder to declined so the three always sum to 100.
  return (going: g, maybe: m, declined: 100 - g - m);
}

/// Championship standings sorted by points, highest first.
/// Ties keep their original order (stable sort).
List<HouseStanding> sortStandings(List<HouseStanding> standings) {
  final copy = List<HouseStanding>.of(standings);
  copy.sort((a, b) => b.points.compareTo(a.points));
  return copy;
}

/// Live leaderboard points: the prototype nudges a house's base points
/// by the current match score (Red 143 + scoreA, Blue 127 + scoreB).
int liveHousePoints(int basePoints, int matchScore) => basePoints + matchScore;

/// Initials from a display name, e.g. "Rahul Menon" -> "RM".
String initialsOf(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  return parts.map((p) => p[0]).take(2).join().toUpperCase();
}

/// Next participant id, e.g. 6 existing -> "P-107".
String nextParticipantId(int existingCount) =>
    'P-${100 + existingCount + 1}';
