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

// Stateless: Top-level root widget that does not hold any mutable state.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Study Tracker',
      home: HomePage(),
    );
  }
}

// Stateless: Page container that arranges other widgets without internal mutable state.
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
            const InfoRow(),
            const SizedBox(height: 12),
            const Tally(),
            const SizedBox(height: 12),
            const Countdown(),
            const SizedBox(height: 12),
            const BuggyCounter(),
          ],
        ),
      ),
    );
  }
}

// Stateless: Displays static info row values based on configuration.
class InfoRow extends StatelessWidget {
  const InfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Start: $startCount', key: const Key('info-start')),
        Text('Step: $stepSize', key: const Key('info-step')),
        Text('Max: $maxCount', key: const Key('info-max')),
      ],
    );
  }
}

// Stateless: Displays student information passed through immutable fields.
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

// Stateless: Computes and displays progress text dynamically based on passed parameters.
class GoalBanner extends StatelessWidget {
  final int count;
  final int max;

  const GoalBanner({
    super.key,
    required this.count,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final int percent = count * 100 ~/ max;
    return Text(
      'Progress: $count of $max ($percent%)',
      key: const Key('progress'),
    );
  }
}

// Stateful: Manages mutable tally count state and provides increment/decrement logic.
class Tally extends StatefulWidget {
  const Tally({super.key});

  @override
  State<Tally> createState() => TallyState();
}

class TallyState extends State<Tally> {
  int _count = startCount;

  void _plus() {
    setState(() {
      _count += stepSize;
      if (_count > maxCount) _count = maxCount;
    });
  }

  void _minus() {
    setState(() {
      _count -= stepSize;
      if (_count < 0) _count = 0;
    });
  }

  void _reset() {
    setState(() {
      _count = startCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Count: $_count', key: const Key('count')),
        GoalBanner(count: _count, max: maxCount),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              key: const Key('plus'),
              onPressed: _plus,
              child: Text('+$stepSize'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              key: const Key('minus'),
              onPressed: _minus,
              child: Text('-$stepSize'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const Key('reset'),
              onPressed: _reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

// Stateful: Manages active timer lifecycle state and tracks total build count.
class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  late int _left;
  late Timer _timer;
  int _builds = 0;

  @override
  void initState() {
    super.initState();
    lifecycleLog.add('initState');
    _left = startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _left--;
      });
      if (_left <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    lifecycleLog.add('dispose');
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _builds++;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _left > 0 ? 'Time left: $_left s' : 'Time is up!',
          key: const Key('time-left'),
        ),
        Text(
          'Builds: $_builds',
          key: const Key('builds'),
        ),
      ],
    );
  }
}

// Stateful: Maintains tap click state and updates text using setState.
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
            setState(() {
              clicks += bugStep;
            });
          },
          child: Text('+$bugStep'),
        ),
      ],
    );
  }
}