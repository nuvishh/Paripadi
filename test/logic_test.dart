import 'package:eventos/logic.dart';
import 'package:eventos/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('perPersonShare', () {
    test('splits the reunion expense evenly', () {
      // ₹63,000 across 42 people = ₹1,500 each (prototype numbers).
      expect(perPersonShare(63000, 42), 1500);
    });

    test('rounds to the nearest rupee', () {
      expect(perPersonShare(10000, 3), 3333);
      expect(perPersonShare(100, 6), 17);
    });

    test('zero people returns zero', () {
      expect(perPersonShare(63000, 0), 0);
      expect(perPersonShare(63000, -2), 0);
    });
  });

  group('checkInRate', () {
    test('4 of 6 checked in is 67%', () {
      expect(checkInRate(4, 6), 67);
    });

    test('all checked in is 100%', () {
      expect(checkInRate(6, 6), 100);
    });

    test('none checked in is 0%', () {
      expect(checkInRate(0, 6), 0);
    });

    test('zero participants returns 0%', () {
      expect(checkInRate(0, 0), 0);
    });
  });

  group('rsvpPercentages', () {
    test('prototype split sums to 100', () {
      final r = rsvpPercentages(going: 75, maybe: 15, declined: 10);
      expect(r.going, 75);
      expect(r.maybe, 15);
      expect(r.declined, 10);
      expect(r.going + r.maybe + r.declined, 100);
    });

    test('rounds and still sums to 100', () {
      final r = rsvpPercentages(going: 1, maybe: 1, declined: 1);
      expect(r.going + r.maybe + r.declined, 100);
    });

    test('zero total returns zeros', () {
      final r = rsvpPercentages(going: 0, maybe: 0, declined: 0);
      expect((r.going, r.maybe, r.declined), (0, 0, 0));
    });
  });

  group('sortStandings', () {
    test('sorts by points, highest first', () {
      const standings = [
        HouseStanding(
          rank: 3,
          name: 'Green House',
          team: 'Vipers',
          gold: 3,
          silver: 2,
          points: 96,
        ),
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
      ];
      final sorted = sortStandings(standings);
      expect(sorted.map((s) => s.name),
          ['Red House', 'Blue House', 'Green House']);
      expect(sorted.map((s) => s.points), [145, 128, 96]);
    });

    test('does not mutate the input list', () {
      const standings = [
        HouseStanding(
          rank: 2,
          name: 'Blue House',
          team: 'Titans',
          gold: 4,
          silver: 5,
          points: 128,
        ),
        HouseStanding(
          rank: 1,
          name: 'Red House',
          team: 'Phoenix',
          gold: 6,
          silver: 3,
          points: 145,
        ),
      ];
      sortStandings(standings);
      expect(standings.first.name, 'Blue House');
    });
  });

  group('liveHousePoints', () {
    test('Red House: 143 base + 2 goals = 145', () {
      expect(liveHousePoints(143, 2), 145);
    });

    test('Blue House: 127 base + 1 goal = 128', () {
      expect(liveHousePoints(127, 1), 128);
    });
  });

  group('initialsOf', () {
    test('two-word name', () {
      expect(initialsOf('Rahul Menon'), 'RM');
    });

    test('single name', () {
      expect(initialsOf('Diya'), 'D');
    });

    test('extra spaces are ignored', () {
      expect(initialsOf('  Sneha   Nair  '), 'SN');
    });
  });

  group('nextParticipantId', () {
    test('6 existing participants -> P-107', () {
      expect(nextParticipantId(6), 'P-107');
    });

    test('empty list -> P-101', () {
      expect(nextParticipantId(0), 'P-101');
    });
  });
}
