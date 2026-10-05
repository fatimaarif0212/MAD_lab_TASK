// lab4.dart   -   Campus Cafe Order System
const String rollNo = '04072313010';

// Seed settings
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10;   // ten digit
final int u = seed % 10;    // unit digit

const List<String> menu = [
  'Chai', 'Latte', 'Mocha', 'Samosa', 'Brownie', 
  'Sandwich', 'Cold Coffee', 'Fries', 'Pakora', 'Zinger Wrap',
];
int priceOf(int i) => 100 + 7 * i + 3 * t; 
final int priceFloor = 60 + 5 * t;
final int taxPercent = 5 + t;
final int bigOrderLimit = 450 + 20 * t;
final int balanceCap = 600 + 20 * t;
final int couponPercent = 5 + t + u;

// Task 1.1: Dish Class
class Dish {
  late String name;
  late int price;
}

class MenuItem {
  String name;
  
 //Task 2.1 & 2.2: MenuItem Class with constructor logic and this. shorthand//
/* Why could price not be declared final in this version of the class? 
Answer: Because we reassign/modify 'price' inside the constructor body, 
 and final fields cannot be modified after they are initialized.*/

  int price;

  // Default constructor with floor logic
  MenuItem(this.name, this.price) {
    if (this.price < priceFloor) {
      this.price = priceFloor;
    }
  }

  // Task 3.1: Named constructor for free items
  MenuItem.free(this.name) : price = 0;

  // Task 3.2: Named constructor parsing from a string
  /*The floor is, say, 80 but free() produced 0. Why did the floor logic not run? 
Answer:The floor logic didn't run because constructor bodies only execute for the default constructor, whereas named constructors have  their own specific initializer lists and skip the default constructor's body.*/
  MenuItem.fromString(String text)
      : name = text.split(':')[0],
        price = int.parse(text.split(':')[1]);
}

// Task 4.1: OrderLog class with a factory constructor for a singleton pattern
class OrderLog {
  static OrderLog? _instance;
  final List<String> entries = [];
  
  OrderLog._internal();                 

 /*Why do _instance and _internal start with an underscore? What could go wrong if they did not?
Answer:They start with an underscore to hide them outside this file. 
If they were not hidden, other code could change them or make new copies,which would ruin the rule of having only one shared log..*/
  factory OrderLog() {
    return _instance ??= OrderLog._internal();
  }

  void add(String msg) => entries.add(msg);
}

// Task 5.1: OrderLine class with final fields
class OrderLine {
  final MenuItem item;
  final int qty;
  final int total;
  final int tax;

  /*Why can an initializer list not read another field (like total) of the same object?
Answer: Because fields in an initializer list are initialized sequentially in order,and 'total' hasn't finished being calculated/created yet when 'tax' is being evaluated.*/
  OrderLine(this.item, this.qty)
      : total = item.price * qty,
        tax = (item.price * qty) * taxPercent ~/ 100,
        assert(qty > 0, 'qty must be positive');

  // Task 6.1: Add three getters inside OrderLine
  int get grand => total + tax;
  bool get isBigOrder => grand > bigOrderLimit;
  String get label => '${item.name} x$qty';
}
  /*Why does line.grand = 5 fail? What would you have to add to make it legal?
Answer: It fails because 'grand' is only a getter (read-only), so it has no setter method. To make it legal, we would need to add a custom setter for 'grand'.*/

// Task 5.2: Top-level function returning a main OrderLine
OrderLine mainOrder() {
  return OrderLine(MenuItem(menu[u], priceOf(u)), 2 + (t + u) % 5);
}

void main() {
  print('Seed: $seed (t=$t, u=$u)');
  step1();
  step2();
  step3();
  step4();
  step5();
  step6();
  step7();
  step8();
  step9();
  step10();
}

void step1() {
  // Task 1.2: Create objects 
  Dish item1 = Dish();
  item1.name = menu[u];
  item1.price = priceOf(u);

  Dish item2 = Dish();
  int idx2 = (u + 1) % 10;
  item2.name = menu[idx2];
  item2.price = priceOf(idx2);
  item2.price = item2.price - u;

  print('Step 1: ${item1.name} Rs ${item1.price}');
  print('Step 1: ${item2.name} Rs ${item2.price}');
}

void step2() {
  // Task 2.3: Create MenuItem objects and print them
  MenuItem a = MenuItem(menu[u], priceOf(u));
  MenuItem b = MenuItem('Test Special', 15 * u);

  print('Step 2: ${a.name} Rs ${a.price}');
  print('Step 2: Test Special Rs ${b.price}');
}

void step3() {
  // Task 3.3: Create freebie and parsed menu item
  MenuItem freebie = MenuItem.free('Water');
  
  int i = (u + 2) % 10;
  MenuItem parsed = MenuItem.fromString('${menu[i]}:${priceOf(i)}');

  print('Step 3: ${freebie.name} Rs ${freebie.price}');
  print('Step 3: ${parsed.name} Rs ${parsed.price}');
  print('Step 3: floor=$priceFloor, free price=${freebie.price}');
}

void step4() {
  // Task 4.2: Create log instances 
  OrderLog log1 = OrderLog();
  OrderLog log2 = OrderLog();

  for (int i = 1; i <= u + 2; i++) {
    String msg = 'order #${100 * t + i}';
    if (i % 2 != 0) {
      log1.add(msg);
    } else {
      log2.add(msg);
    }
  }

  print('Step 4: same object? ${identical(log1, log2)}');
  print('Step 4: entries = ${log1.entries.length}');
  print('Step 4: last = ${log2.entries.last}');
}

void step5() {
  // Task 5.3: Test mainOrder and verify assertion handling
  OrderLine line = mainOrder();
  print('Step 5: ${line.item.name} x${line.qty}');
  print('Step 5: total=${line.total} tax=${line.tax}');

  try {
    OrderLine(line.item, 0);
    print('Step 5: assert did NOT fire');
  } on AssertionError {
    print('Step 5: assert fired');
  }
}

void step6() {
  // Task 6.2: Use mainOrder and print getter results
  OrderLine line = mainOrder();
  print('Step 6: grand=${line.grand}');
  print('Step 6: big order? ${line.isBigOrder} (limit $bigOrderLimit)');
  print('Step 6: label=${line.label}');
}

void step7() { print('--- Step 7 ---'); }
void step8() { print('--- Step 8 ---'); }
void step9() { print('--- Step 9 ---'); }
void step10(){ print('--- Step 10 ---'); }