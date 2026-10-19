// main.dart Study Tracker lab
import 'dart:async';
import 'package:flutter/material.dart';

const String studentName = 'Fatima Arif';
const String rollNo = '04072313010';

//===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int $t = seed ~/ 10; // tens digit
final int $u = seed % 10; // units digit

const List<String> courses = [
  'Mobile Dev', 'Data Structures', 'Operating Systems', 'Databases',
  'Networks', 'Software Eng', 'AI', 'Web Engineering', 'Graphics', 'Security',
];

final String course = courses[$u];
final int startCount = 3 + $u;
final int stepSize = 1 + $t ~/ 4;
final int maxCount = 20 + 2 * $t;
final int startSeconds = 5 + ($t + $u) % 6;
final int bugStep = 1 + $u * 4;

final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

// Keep the name LabApp and its const constructor: the checker uses them.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Think Answer:
    // runApp receives the root widget of the entire Flutter widget tree, 
    // whereas MaterialApp.home receives the default root page/screen widget of the app.
    return const MaterialApp(
      title: 'Study Tracker',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Tracker: $course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentCard(
              name: studentName,
              roll: rollNo,
              course: course,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start: $startCount', key: const Key('info-start')),
                Text('Step: $stepSize', key: const Key('info-step')),
                Text('Max: $maxCount', key: const Key('info-max')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// StudentCard definition
class StudentCard extends StatelessWidget {
  final String name;
  final String roll;
  final String course;

  const StudentCard({
    super.key,
    required this.name,
    required this.roll,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    // Think Answer:
    // Fields of StatelessWidget must be final because the widget object is immutable. 
    // Removing final causes a compiler error/warning when using const constructors.
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', key: const Key('student-name')),
            Text('Roll no: $roll', key: const Key('student-roll')),
            Text('Course: $course', key: const Key('student-course')),
          ],
        ),
      ),
    );
  }
}

class BuggyCounter extends StatefulWidget {
  const BuggyCounter({super.key});

  @override
  State<BuggyCounter> createState() => BuggyCounterState();
}

class BuggyCounterState extends State<BuggyCounter> {
  int clicks = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Bug clicks: $clicks', key: const Key('bug-text')),
        const SizedBox(width: 12),
        ElevatedButton(
          key: const Key('bug-button'),
          onPressed: () {
            clicks += bugStep;
          },
          child: Text('+$bugStep'),
        ),
      ],
    );
  }
}