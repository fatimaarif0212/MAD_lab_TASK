// lab3.dart   Campus Cafe Order System
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

  // Task 8.1: toString override for nice formatting
  @override
  String toString() => '$name (Rs $price)';
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

// Task 7.1: StudentCard class with private backing field and validating setter
class StudentCard {
  final String owner;
  int _balance;                       

  StudentCard(this.owner) : _balance = 0;

  int get balance => _balance;

  /* The setter silently clamps a bad value. What is one other thing a setter could do with an invalid value?
  Answer: It could throw an exception or ignore the assignment entirely. */
  set balance(int v) {
    if (v < 0) {
      _balance = 0;
    } else if (v > balanceCap) {
      _balance = balanceCap;
    } else {
      _balance = v;
    }
  }
}

// Task 5.2: Top-level function returning a main OrderLine
OrderLine mainOrder() {
  return OrderLine(MenuItem(menu[u], priceOf(u)), 2 + (t + u) % 5);
}

// Task 8.2: Top-level buildMenu function using collection-for
List<MenuItem> buildMenu() {
  return [
    for (int k = 0; k < 4; k++)
      () {
        int idx = (u + 3 * k) % 10;
        return MenuItem.fromString('${menu[idx]}:${priceOf(idx)}');
      }()
  ];
}

// Task 9.1: Top-level buildReceipt function
List<OrderLine> buildReceipt() {
  List<MenuItem> items = buildMenu();
  return [
    for (int k = 0; k < 3; k++)
      OrderLine(items[k], 1 + (t + k) % 4)
  ];
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

void step7() {
  // Task 7.2: Create StudentCard and run test assignments with validation
  StudentCard card = StudentCard('S$seed');
  
  card.balance = seed * 10 + 50;
  print('Step 7: topped up -> ${card.balance}');

  card.balance = -seed - 1;
  print('Step 7: bad value -> ${card.balance}');

  card.balance = balanceCap - u;
  print('Step 7: reset -> ${card.balance}');

  card.balance = card.balance - mainOrder().grand;
  print('Step 7: paid order -> ${card.balance}');
}

void step8() {
  // Task 8.3: Call buildMenu, reduce, and fold
  List<MenuItem> items = buildMenu();
  MenuItem priciest = items.reduce((a, b) => a.price > b.price ? a : b);
  int sum = items.fold(0, (acc, item) => acc + item.price);

  print('Step 8: menu = $items');
  print('Step 8: priciest = ${priciest.name}');
  print('Step 8: sum = $sum');
}

void step9() {
  // Task 9.2: Process receipt lines, log labels, calculate total, and print results
  List<OrderLine> receipt = buildReceipt();
  int receiptTotal = 0;

  for (var line in receipt) {
    print('Step 9: ${line.label} = ${line.grand}');
    OrderLog().add('receipt: ${line.label}');
    receiptTotal += line.grand;
  }

  print('Step 9: receipt total = $receiptTotal');
  print('Step 9: log size = ${OrderLog().entries.length}');
}
// Task 10.1: Coupon Class
class Coupon {
  static final Map<String, Coupon> _cache = {};
  final String code;
  final int percent;
  final int minSpend;

  // Main constructor with initializer list and assertion
  Coupon(this.code, this.percent)
      : minSpend = percent * 70,
        assert(percent >= 1 && percent <= 50, 'Percent must be between 1 and 50');

  // Factory constructor 
  factory Coupon.fromCode(String code) {
    return _cache.putIfAbsent(code, () => Coupon(code, couponPercent));
  }

  // Calculate discount based on minSpend threshold
  int discountOn(int amount) {
    if (amount >= minSpend) {
      return amount * percent ~/ 100;
    }
    return 0;
  }
}

// Task 10
void step10() {
  
  String code = 'CAFE${seed.toString().padLeft(2, '0')}';
  
  Coupon c1 = Coupon.fromCode(code);
  Coupon c2 = Coupon.fromCode(code);
  
  List<OrderLine> receiptLines = buildReceipt();
  int receipt = receiptLines.fold(0, (sum, line) => sum + line.grand);
  
  //Compute discount and print outputs
  int discount = c1.discountOn(receipt);
  
  print('Step 10: ${c1.code} gives ${c1.percent}% off, min spend ${c1.minSpend}');
  print('Step 10: cached? ${identical(c1, c2)}');
  print('Step 10: receipt $receipt, discount $discount, payable ${receipt - discount}');
}
/*Q1. Animal(this.name, this.type); and the verbose constructor give the same result. What does the shorthand save you? 
Answer:Instead of declaring parameters and manually writing this.name = name; inside the constructor body, the this. shorthand creates the parameters and assigns them to the fields all in one step.

Q2. When would you choose a named constructor, and when a factory constructor? 
Answer:Named constructor: Use it when you want different ways to create a brand new instance of a class (for example, Animal.dog(name) vs. Animal.cat(name)).
Factory constructor: Use it when you do not always want to create a new instance. It lets you return an existing cached instance (like a singleton), return a subclass object, or read data first before deciding what to return.

Q3. What is the difference between assigning a field in a constructor body and assigning it in an initializer list? 
Answer:An initializer list runs before the object is created, making it the only way to assign final fields, though it cannot access this or read other object properties. The constructor body runs after object creation, allowing complex logic like if statements and this access, but it cannot assign final fields.

Q4. Give one reason to use a getter instead of storing the value in a field, and one reason to use a setter instead of a public field. 
Answer:To calculate a value on-the-fly without wasting memory saving it (for example, calculating grandTotal = price + tax dynamically every time it is requested).
To validate or restrict data before saving it (for example, ensuring balance cannot be set to a negative number).*/
