// Data models for Paripadi. All sample data lives in EventStore.

enum EventType { sports, social }

class EventItem {
  EventItem({
    required this.id,
    required this.title,
    required this.type,
    required this.subtitle,
    required this.date,
    required this.location,
    required this.badge,
  });

  final String id;
  final String title;
  final EventType type;
  final String subtitle;
  final String date;
  final String location;
  final String badge;

  bool get isSports => type == EventType.sports;
  bool get isLive => badge == 'Live Tournament';
}

class Participant {
  Participant({
    required this.id,
    required this.name,
    required this.meta,
    required this.role,
    required this.food,
    required this.paid,
    required this.checkedIn,
  });

  final String id;
  final String name;
  final String meta; // House / Team (sports) or food pref context (social)
  final String role;
  final String food; // 'Veg' | 'Non-Veg'
  final bool paid;
  final bool checkedIn;

  Participant copyWith({bool? paid, bool? checkedIn}) => Participant(
        id: id,
        name: name,
        meta: meta,
        role: role,
        food: food,
        paid: paid ?? this.paid,
        checkedIn: checkedIn ?? this.checkedIn,
      );

  String get passId => 'PASS #$id-2026';

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.map((p) => p[0]).take(2).join().toUpperCase();
  }
}

class HouseStanding {
  const HouseStanding({
    required this.rank,
    required this.name,
    required this.team,
    required this.gold,
    required this.silver,
    required this.points,
  });

  final int rank;
  final String name; // Red House
  final String team; // Phoenix
  final int gold;
  final int silver;
  final int points;

  String get label => '$name ($team)';
  String get medals => '$gold Gold • $silver Silver';
}

class Fixture {
  const Fixture({
    required this.title,
    required this.detail,
    required this.status,
    required this.isCompleted,
  });

  final String title;
  final String detail;
  final String status; // 'Next Up' | 'Completed'
  final bool isCompleted;
}

class RsvpStats {
  const RsvpStats({
    required this.confirmed,
    required this.goingPercent,
    required this.maybePercent,
    required this.declinedPercent,
    required this.vegPlates,
    required this.nonVegPlates,
    required this.pollTitle,
    required this.pollDetail,
  });

  final int confirmed;
  final int goingPercent;
  final int maybePercent;
  final int declinedPercent;
  final int vegPlates;
  final int nonVegPlates;
  final String pollTitle;
  final String pollDetail;
}
