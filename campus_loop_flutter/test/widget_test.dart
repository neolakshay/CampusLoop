import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:campus_loop_flutter/screens/create_activity_screen.dart';
import 'package:campus_loop_flutter/state/activity_state.dart';
import 'package:campus_loop_flutter/widgets/activity_card.dart';
import 'package:campus_loop_flutter/widgets/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('activity card does not guess attendee count', (tester) async {
    final activity = _activity();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activity: activity,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Capacity up to 10 attendees'), findsOneWidget);
    expect(find.text('1 / 10 attending (9 spots left)'), findsNothing);
  });

  testWidgets('activity card shows the backend attendee count', (tester) async {
    final activity = _activity();
    final details = ActivityDetails(
      activity: activity,
      attendeeCount: 4,
      isAttending: false,
      isOrganizer: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activity: activity,
            cachedDetails: details,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('4 / 10 attending (6 spots left)'), findsOneWidget);
  });

  testWidgets('study session form requires a topic before submitting', (
    tester,
  ) async {
    final state = ActivityState();
    addTearDown(state.dispose);

    await tester.pumpWidget(
      MaterialApp(home: CreateActivityScreen(state: state)),
    );
    await tester.tap(find.text('Publish Study Session'));
    await tester.pumpAndSettle();

    expect(
      find.text('A study session needs a course or topic'),
      findsOneWidget,
    );
  });

  testWidgets('filter bar triggers callbacks for chips and search', (
    tester,
  ) async {
    ActivityKind? selectedKind;
    String searchQuery = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterBar(
            selectedKind: selectedKind,
            onKindSelected: (kind) => selectedKind = kind,
            searchQuery: searchQuery,
            onSearchChanged: (q) => searchQuery = q,
          ),
        ),
      ),
    );

    expect(find.text('All Activities'), findsOneWidget);
    expect(find.text('Campus Events'), findsOneWidget);
    expect(find.text('Study Sessions'), findsOneWidget);

    await tester.tap(find.text('Study Sessions'));
    await tester.pumpAndSettle();
    expect(selectedKind, ActivityKind.studySession);

    await tester.enterText(
      find.byType(TextField),
      'Algorithms',
    );
    expect(searchQuery, 'Algorithms');
  });

  testWidgets('activity card reflects cancelled state', (tester) async {
    final activity = CampusActivity(
      kind: ActivityKind.studySession,
      title: 'CS 101 Midterm Study',
      description: 'Review chapters 1-4.',
      topic: 'Computer Science',
      startsAt: DateTime.now().toUtc().add(const Duration(days: 2)),
      location: 'Room 204',
      organizerName: 'Peer Tutor',
      status: ActivityStatus.cancelled,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activity: activity,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('CS 101 Midterm Study'), findsOneWidget);
  });
}

CampusActivity _activity() {
  final startsAt = DateTime.now().toUtc().add(const Duration(days: 3));
  return CampusActivity(
    kind: ActivityKind.event,
    title: 'Campus event',
    description: 'A campus gathering for students.',
    startsAt: startsAt,
    endsAt: startsAt.add(const Duration(hours: 1)),
    location: 'Central Library',
    capacity: 10,
    organizerName: 'Student host',
  );
}
