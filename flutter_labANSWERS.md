Fatima Arif
04072313010

A1: 19
A2: 6
A3: 3
A4: 13

B1:
- Stateless: LabApp, HomePage, InfoRow, StudentCard, GoalBanner. Unke pass operational runtime state change nahi hoti.
- Stateful: Tally, Countdown, BuggyCounter. Ye dynamic changes ko build method trigger karke re-render karte hain (setState / Timers).

B2:
Timer ko dispose() mein cancel karna zaroori hai taaki memory leaks na hon aur unmounted widget par setState() call hone ka error na aaye.

B3:
Immutable widgets (jaise Key, SizedBox, static Text, StudentCard) const ho sakte hain. Const compile-time par widget instances ko reuse karta hai aur unnecessary rebuilds ko roktay hue performance improve karta hai.