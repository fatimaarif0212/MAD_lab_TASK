# Team Board Lab Answers

Name: Fatima Arif  
Roll Number: 04072313010  

## Quantitative Answers
A1: 14  
A2: 5  
A3: 3  
A4: 3  

## Conceptual Answers

### B1: Stateless vs Stateful Widgets
StatelessWidgets:`LabApp`, `HomePage`, `SettingsCard`, `SummaryRow`, `Probe`, `Welcome`, `AxisBoard`, `FixedSummaryRow`, `FixedSummaryWrap`, `FlexBoard`, `StyledBox`, and `StampedBox`. They do not maintain internal mutable state over time; they simply build their subtree based on immutable input parameters.
StatefulWidgets:`Clock`, `Tile`, and `SwapBoard`. They manage dynamic mutable state that changes during runtime (`_seconds` and `builds` in `Clock`, `taps` in `Tile`, and `tiles` list order in `SwapBoard`) using `setState` to trigger UI updates.

B2: Widget, Element, and RenderObject
Widget:Rebuilt on every `setState`. Widgets are immutable, lightweight, and cheap configuration blueprints that Flutter frequently creates and destroys.
Element & RenderObject:Kept across rebuilds. The Element acts as the persistent lifecycle bridge managing State, while the RenderObject handles measuring, layout, and rendering onto the screen.
Probe Findings:The `Probe` widget confirmed this architecture by displaying changing identity hash codes for the `Widget` instance on every tick (showing it is repeatedly recreated), while the `Element` hash code remained identical (showing it persists in memory).

B3: "Constraints Go Down, Sizes Go Up"
In Step 7's `SummaryRow`, the `Row` passes unbounded horizontal constraints down to its `Text` children. The `Text` widgets measure their full unconstrained string length and pass those large sizes back up, causing an overflow error. When wrapped in `Expanded`, `Row` passes strict maximum width constraints down to each child. The children then size themselves strictly within those assigned bounds before reporting their resulting dimensions back up the tree.