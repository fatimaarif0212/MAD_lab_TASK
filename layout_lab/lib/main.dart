// main.dart - Team Board lab
import 'dart:async';
import 'package:flutter/material.dart';

const String studentName = 'Fatima Arif';
const String rollNo = '04072313010'; // Seed generated from last two digits: 10

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10; // tens digit
final int u = seed % 10; // units digit

const List<String> courses = [
  'Mobile Dev',
  'Data Structures',
  'Operating Systems',
  'Databases',
  'Networks',
  'Software Eng',
  'AI',
  'Web Engineering',
  'Graphics',
  'Security',
];
const List<String> names = ['Ali', 'Sara', 'Omar', 'Hina', 'Zain', 'Maya'];
const List<String> mains = [
  'start',
  'center',
  'end',
  'spaceBetween',
  'spaceAround',
  'spaceEvenly',
];
const List<String> crosses = ['start', 'center', 'end'];
const List<String> hues = ['teal', 'indigo', 'orange', 'pink', 'green'];
const Map<String, MaterialColor> swatches = {
  'teal': Colors.teal,
  'indigo': Colors.indigo,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'green': Colors.green,
};

final String course = courses[u];

// Steps 1-2: the clock
final int startSec = 5 * (1 + t % 5); // where the clock starts
final int tick = 1 + u % 3; // how much it adds every second
final int ticks = 4 + u % 4; // how many ticks until it stops
final int stopAt = startSec + ticks * tick; // the clock stops here

// Steps 4-5: the tiles
final String tileA = names[u % 6];
final String tileB = names[(u + 2) % 6];
final String tileC = names[(u + 4) % 6];
final int tapsToMake = 2 + t % 3; // used by the experiment in Step 5

// Step 6: axes (the NAMES are printed on the settings card; you type the enum)
final String mainName = mains[u % 6];
final String crossName = crosses[t % 3];

// Step 8: Expanded and Flexible
final double fixedW = 70.0 + 10 * u;
final int flexA = 1 + t % 3;
final int flexB = 1 + u % 2;

// Step 9: Container
final double boxMargin = 4.0 + 2 * (t % 5);
final double boxPad = 8.0 + 2 * (u % 5);
final double boxRadius = 4.0 * (1 + (t + u) % 4);
final double boxBorder = 1.0 + t % 3;
final String hue = hues[(t + u) % 5]; // use swatches[hue]!.shade100

// Step 10: Stack
final double dotTop = 4.0 + 4 * (t % 4);
final double dotRight = 4.0 + 4 * (u % 4);
final double dotBottom = 4.0 + 4 * ((t + u) % 4);
final double dotLeft = 4.0 + 4 * ((t + 2 * u) % 4);

// ===========================================================================

// Step 2 writes to this list from initState and dispose.
final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

// Keep the name LabApp and its const constructor: the checker uses them.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Team Board', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Board: $course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsCard(),
            const SizedBox(height: 12),
            const Welcome(), // Step 4 Widget
            const SizedBox(height: 12),
            const Clock(), // Steps 1-3 Widget
            const SizedBox(height: 12),
            const SwapBoard(), // Step 5 Widget
            const SizedBox(height: 12),
            const AxisBoard(), // Step 6 Widget
            const SizedBox(height: 12),
            const SummaryRow(), // Step 7: Provided unconstrained row (overflows)
            const SizedBox(height: 12),
            const FixedSummaryRow(), // Step 7: Fixed with Expanded
            const SizedBox(height: 12),
            const FixedSummaryWrap(), // Step 7: Fixed with Wrap
            const SizedBox(height: 12),
            const FlexBoard(), // Step 8 Widget
            const SizedBox(height: 12),
            const StyledBox(), // Step 9 Widget
            const SizedBox(height: 12),
            const StampedBox(), // Step 10 Widget
          ],
        ),
      ),
    );
  }
}

// ---- Provided: shows YOUR numbers. Keep it on the page. Do not rename.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'YOUR SETTINGS (seed $seed)\n'
      'clock: start $startSec, tick $tick, stop at $stopAt\n'
      'tiles: $tileA, $tileB, $tileC (taps for the Step 5 experiment: $tapsToMake)\n'
      'row main axis: $mainName | column cross axis: $crossName\n'
      'flex: $flexA and $flexB | fixed width: ${fixedW.toStringAsFixed(0)}\n'
      'box: margin $boxMargin, padding $boxPad, radius $boxRadius, '
      'border $boxBorder, colour $hue\n'
      'stamp: top $dotTop, right $dotRight, bottom $dotBottom, left $dotLeft',
      key: const Key('settings'),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}

// ---- Provided for Step 7. It overflows on purpose. Do not rename anything.
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Part A: read the widget tree of the $course board from top to bottom.',
          key: const Key('sum-a'),
        ),
        Text(
          'Part B: build each box from small widgets and never extend a builtin class.',
          key: const Key('sum-b'),
        ),
        Text(
          'Part C: break the layout on purpose, then fix it with Expanded or Wrap.',
          key: const Key('sum-c'),
        ),
      ],
    );
  }
}

// ===== Steps 1 & 2: The Clock with Lifecycle Logging =====
class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  int _seconds = startSec;
  int builds = 0; // Task 2.2 field

  @override
  void initState() {
    super.initState(); // Task 1.2: super.initState() called first
    lifecycleLog.add('initState'); // Task 2.1: log initState
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds += tick);
      if (_seconds >= stopAt) timer.cancel(); // Stop at limit
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Task 2.1: first cancel timer
    lifecycleLog.add('dispose'); // Task 2.1: log dispose
    super.dispose(); // Task 2.1: super.dispose() called last
  }

  /* 
    Think Comment (Step 1):
    Why do we start the Timer in initState and not inside build?
    initState runs only once when the widget is created. If we put the Timer inside build(), 
    every time setState() is called, build() runs again and creates a new timer. 
    This would start many timers at the same time, making the clock count much faster 
    and wasting memory.

    Think Comment (Step 2):
    Why does Builds go up by one per second and not by two?
    The timer fires once every second, triggering setState() once per second, which causes 
    build() to execute exactly once.
    
    What error would you see if timer.cancel() was missing from dispose()?
    If the widget leaves the screen without cancelling the timer, calling setState() on a 
    disposed state object throws a Flutter error: "setState() called after dispose()".
  */

  @override
  Widget build(BuildContext context) {
    builds++; // Task 2.2: increment builds count
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session: $_seconds s',
          key: const Key('clock'),
        ),
        Text(
          'Builds: $builds',
          key: const Key('builds'),
        ),
        Probe(seconds: _seconds), // Step 3 (Task 3.3)
      ],
    );
  }
}

// ===== Step 3: BuildContext: Widget vs Element =====
class Probe extends StatelessWidget {
  final int seconds;
  const Probe({super.key, required this.seconds});

  /* 
    Think Comment (Step 3):
    Which of Widget or Element is "cheap and thrown away" and which keeps State?
    The Widget is immutable, cheap, and thrown away on every rebuild.
    The Element is persistent, stays in memory, and manages/holds the State.

    Where is the third one, the RenderObject, and what is its job?
    The RenderObject sits in the Render Tree beneath the Element tree.
    Its job is to handle layout (measuring sizes, positioning) and actual painting on screen.
  */

  @override
  Widget build(BuildContext context) {
    final Scaffold? scaffold = context.findAncestorWidgetOfExactType<Scaffold>();
    final bool above = scaffold != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seen at: $seconds s',
          key: const Key('probe-seen'),
        ),
        Text(
          'Widget #${identityHashCode(this)}',
          key: const Key('probe-widget'),
        ),
        Text(
          'Element #${identityHashCode(context)}',
          key: const Key('probe-element'),
        ),
        Text(
          'Context belongs to: ${context.widget.runtimeType}',
          key: const Key('probe-context'),
        ),
        Text(
          'Scaffold above me: $above',
          key: const Key('probe-above'),
        ),
      ],
    );
  }
}

// ===== Step 4: Composition and the Tile =====
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome, $studentName',
        key: const Key('welcome'),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final String label;
  const Tile(this.label, {super.key});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  int taps = 0;

  /* 
    Think Comment (Step 4):
    You built Tile out of an ElevatedButton without writing extends ElevatedButton. 
    What is this style called, and why does Flutter prefer it?
    This style is called Composition (combining small widgets together). 
    Flutter prefers composition over inheritance because it makes code much more flexible, 
    reusable, and easier to customize without creating complex class hierarchies.
  */

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => taps++),
      child: Text('${widget.label} : $taps'),
    );
  }
}

// ===== Step 5: Keys: Swapping Tiles =====
class SwapBoard extends StatefulWidget {
  const SwapBoard({super.key});

  @override
  State<SwapBoard> createState() => _SwapBoardState();
}

class _SwapBoardState extends State<SwapBoard> {
  var tiles = <Widget>[
    Tile(tileA, key: ValueKey(tileA)),
    Tile(tileB, key: ValueKey(tileB)),
    Tile(tileC, key: ValueKey(tileC)),
  ];

  void swap() => setState(() => tiles = tiles.reversed.toList());

  /* 
    Think Comment (Step 5):
    Without keys, why did the number stay at the left even though the label moved?
    Without keys, Flutter matches new widgets to old Elements solely by widget type and position in 
    the tree. Since all widgets are of type Tile and in the same positions, Flutter keeps the 
    existing Element and State objects in place (keeping the tap counter on the left) and only 
    updates the widget's label property.
  */

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: tiles),
        ElevatedButton(
          key: const Key('swap'),
          onPressed: swap,
          child: const Text('Swap'),
        ),
      ],
    );
  }
}

// ===== Step 6: MainAxisAlignment and CrossAxisAlignment =====
class AxisBoard extends StatelessWidget {
  const AxisBoard({super.key});

  static const Map<String, MainAxisAlignment> mainMap = {
    'start': MainAxisAlignment.start,
    'center': MainAxisAlignment.center,
    'end': MainAxisAlignment.end,
    'spaceBetween': MainAxisAlignment.spaceBetween,
    'spaceAround': MainAxisAlignment.spaceAround,
    'spaceEvenly': MainAxisAlignment.spaceEvenly,
  };

  static const Map<String, CrossAxisAlignment> crossMap = {
    'start': CrossAxisAlignment.start,
    'center': CrossAxisAlignment.center,
    'end': CrossAxisAlignment.end,
  };

  /* 
    Think Comment (Step 6):
    In Row, which axis is main and which is cross?
    In Row, main axis is horizontal (left to right) and cross axis is vertical (top to bottom).
    In Column, main axis is vertical (top to bottom) and cross axis is horizontal (left to right).
  */

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('axis-col'),
      crossAxisAlignment: crossMap[crossName]!,
      children: [
        Row(
          key: const Key('axis-row'),
          mainAxisAlignment: mainMap[mainName]!,
          children: const [
            Text('A', key: Key('axis-a')),
            Text('B', key: Key('axis-b')),
            Text('C', key: Key('axis-c')),
          ],
        ),
      ],
    );
  }
}

// ===== Step 7: Layout Overflow & Fixing It =====
class FixedSummaryRow extends StatelessWidget {
  const FixedSummaryRow({super.key});

  /* 
    Think Comment (Step 7):
    Why does SummaryRow throw an overflow error, and how do Expanded and Wrap fix it differently?
    SummaryRow throws an overflow error because a Row gives its children unconstrained width, causing 
    long text widgets to extend beyond the screen boundaries.
    Expanded fixes this by forcing children to fit inside the remaining available row width, wrapping text multiline.
    Wrap fixes this by moving any child that doesn't fit on the current line down to a new row/line.
  */

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Part A: read the widget tree of the $course board from top to bottom.',
            key: const Key('sum-a-exp'),
          ),
        ),
        Expanded(
          child: Text(
            'Part B: build each box from small widgets and never extend a builtin class.',
            key: const Key('sum-b-exp'),
          ),
        ),
        Expanded(
          child: Text(
            'Part C: break the layout on purpose, then fix it with Expanded or Wrap.',
            key: const Key('sum-c-exp'),
          ),
        ),
      ],
    );
  }
}

class FixedSummaryWrap extends StatelessWidget {
  const FixedSummaryWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          'Part A: read the widget tree of the $course board from top to bottom.',
          key: const Key('sum-a-wrap'),
        ),
        Text(
          'Part B: build each box from small widgets and never extend a builtin class.',
          key: const Key('sum-b-wrap'),
        ),
        Text(
          'Part C: break the layout on purpose, then fix it with Expanded or Wrap.',
          key: const Key('sum-c-wrap'),
        ),
      ],
    );
  }
}

// ===== Step 8: Flex: Expanded and Flexible =====
class FlexBoard extends StatelessWidget {
  const FlexBoard({super.key});

  /* 
    Think Comment (Step 8):
    What is the difference between Expanded and Flexible(fit: FlexFit.loose)?
    Expanded forces its child to fill all the available space assigned by its flex factor (FlexFit.tight).
    Flexible with FlexFit.loose allows its child to be smaller than the allocated space if its natural content size is smaller.
  */

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: fixedW,
          child: Text('Fixed: ${fixedW.toStringAsFixed(0)}', key: const Key('flex-fixed')),
        ),
        Expanded(
          flex: flexA,
          child: Text('Expanded flex $flexA', key: const Key('flex-exp')),
        ),
        Flexible(
          flex: flexB,
          fit: FlexFit.loose,
          child: Text('Flexible flex $flexB', key: const Key('flex-flex')),
        ),
      ],
    );
  }
}

// ===== Step 9: Container and Decoration =====
class StyledBox extends StatelessWidget {
  const StyledBox({super.key});

  /* 
    Think Comment (Step 9):
    What happens if you supply both color and decoration to a Container?
    Supplying both color and decoration parameters to Container throws an assertion error 
    ("Cannot provide both a color and a decoration") because color must be defined inside 
    BoxDecoration when decoration is present.
  */

  @override
  Widget build(BuildContext context) {
    final swatch = swatches[hue]!;
    return Container(
      key: const Key('box-container'),
      margin: EdgeInsets.all(boxMargin),
      padding: EdgeInsets.all(boxPad),
      decoration: BoxDecoration(
        color: swatch.shade100,
        borderRadius: BorderRadius.circular(boxRadius),
        border: Border.all(
          color: swatch.shade700,
          width: boxBorder,
        ),
      ),
      child: Text(
        'Box ($hue)',
        key: const Key('box-text'),
      ),
    );
  }
}

// ===== Step 10: Stack and Positioned =====
class StampedBox extends StatelessWidget {
  const StampedBox({super.key});

  /* 
    Think Comment (Step 10):
    How does Stack order its children from back to front?
    Stack renders its children in declaration order: the first child in the list is at the bottom (back), 
    and subsequent children are rendered on top of preceding children (front).
  */

  @override
  Widget build(BuildContext context) {
    final swatch = swatches[hue]!;
    return Stack(
      key: const Key('stamp-stack'),
      children: [
        const StyledBox(),
        Positioned(
          top: dotTop,
          right: dotRight,
          bottom: dotBottom,
          left: dotLeft,
          child: Container(
            key: const Key('stamp-dot'),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: swatch.shade700,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}