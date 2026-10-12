// library_lab.dart  (Campus Library System)
const String rollNo = '04072313010';

//Seeded settings 
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10;   // ten digit
final int u = seed % 10;    // unit digit

const List<String> titles = [
  'Dart Basics', 'Flutter In Action', 'Data Structures', 'Operating Systems',
  'Mobile Design', 'Clean Code', 'Algorithms Unlocked', 'Computer Networks',
  'Database Systems', 'Software Testing',
];

int yearOf(int i) => 1995 + 2 * i + t;     
final int feePerDay = 5 + t;                
final int daysLate = 3 + (t + u) % 6;       
final int daysBig = 10 + u;                 
final int feeCap = 150 + 10 * t;            
final int renewLimit = 1 + t % 3;           
final int renewAttempts = 2 + u;            
final int shelfSize = 3 + u % 4;          


//abstract class
abstract class Borrowable {
  bool get isAvailable;
  void borrow();
  void giveBack();
}

//mixin
mixin Renewable {
  int renewals = 0;

  bool renew(int limit) {
    if (renewals >= limit) {
      return false;
    }
    renewals++;
    return true;
  }
}
//abstract class
abstract class LibraryItem {
  final String title;
  final int year;

 // Static member counter (Step 9)
  static int created = 0;

  LibraryItem(this.title, this.year) {
    created++;
  }

  // Step 2
  String describe() => '$title ($year)';

  // Step 3
  int lateFee(int days);

  // Step 9
  static int capFee(int fee) {
    return fee > feeCap ? feeCap : fee;
  }
}
// Step 1, 2, 3, 4, 5
class Book extends LibraryItem with Renewable implements Borrowable {
  final int pages;
  bool _out = false;

  Book(super.title, super.year, this.pages);

  @override
  String describe() => '${super.describe()}, $pages pages';

  @override
  int lateFee(int days) => days * feePerDay;

  @override
  bool get isAvailable => !_out;

  @override
  void borrow() {
    _out = true;
  }

  @override
  void giveBack() {
    _out = false;
  }
}

// Step 2, 3
class Magazine extends LibraryItem {
  final int issue;

  Magazine(super.title, super.year, this.issue);

  @override
  String describe() => '${super.describe()}, issue $issue';

  @override
  int lateFee(int days) => days * (feePerDay ~/ 2);
}

// Step 3, 5
class Dvd extends LibraryItem with Renewable {
  final int minutes;

  Dvd(super.title, super.year, this.minutes);

  @override
  String describe() => '${super.describe()}, $minutes min';

  @override
  int lateFee(int days) => days * feePerDay * 2;
}

// ENHANCED ENUMS
enum MemberType {
  student(3, 50),
  faculty(10, 20),
  guest(1, 0);

  final int maxLoans;
  final int discountPercent;

  const MemberType(this.maxLoans, this.discountPercent);

  int applyDiscount(int fee) {
    return fee - (fee * discountPercent ~/ 100);
  }
}

// STEP 7
extension MoneyText on int {
  String get rs => 'Rs $this';
}

extension Initials on String {
  String get initials => split(' ').map((w) => w[0]).join();
}

extension ShelfMath on List<LibraryItem> {
  int totalLateFee(int days) => fold(0, (sum, item) => sum + item.lateFee(days));
}
//STEP 8
class Fine {
  final int amount;

  const Fine(this.amount);

  Fine operator +(Fine o) => Fine(amount + o.amount);
  bool operator >(Fine o) => amount > o.amount;

  @override
  bool operator ==(Object other) => other is Fine && other.amount == amount;

  @override
  int get hashCode => amount.hashCode;

  @override
  String toString() => 'Fine($amount)';
}

//STEP 10
class Member {
  final String name;
  final MemberType type;

  Member(this.name, this.type);

  Fine feeFor(LibraryItem item, int days) {
    int fee = item.lateFee(days);
    int capped = LibraryItem.capFee(fee);
    int discounted = type.applyDiscount(capped);
    return Fine(discounted);
  }
}

Book mainBook() {
  return Book(titles[u], yearOf(u), 100 + 3 * seed);
}

Magazine mainMagazine() {
  int i = (u + 1) % 10;
  return Magazine(titles[i], yearOf(i), 1 + (t + u) % 12);
}

Dvd mainDvd() {
  int i = (u + 2) % 10;
  return Dvd(titles[i], yearOf(i), 90 + seed % 40);
}

List<LibraryItem> buildShelf() {
  List<LibraryItem> shelf = [];
  for (int k = 0; k < shelfSize; k++) {
    int i = (u + k) % 10;
    if (k % 3 == 0) {
      shelf.add(Book(titles[i], yearOf(i), 100 + 3 * seed));
    } else if (k % 3 == 1) {
      shelf.add(Magazine(titles[i], yearOf(i), 1 + (t + k) % 12));
    } else {
      shelf.add(Dvd(titles[i], yearOf(i), 90 + seed % 40));
    }
  }
  return shelf;
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
  print('--- Step 1 ---');
  Book b = mainBook();
  LibraryItem item = b;

  print('Step 1: ${b.title} (${b.year}), ${b.pages} pages');
  print('Step 1: stored as LibraryItem: ${item.title}');
  print('Step 1: runtimeType = ${item.runtimeType}');
}
void step2() {
  print('--- Step 2 ---');
  print('Step 2: ${mainBook().describe()}');
  print('Step 2: ${mainMagazine().describe()}');
}

void step3() {
  print('--- Step 3 ---');
  Book b = mainBook();
  Magazine m = mainMagazine();
  Dvd d = mainDvd();

  print('Step 3: Book late fee for $daysLate days = ${b.lateFee(daysLate)}');
  print('Step 3: Magazine late fee for $daysLate days = ${m.lateFee(daysLate)}');
  print('Step 3: Dvd late fee for $daysLate days = ${d.lateFee(daysLate)}');
}

void step4() {
  print('--- Step 4 ---');
  Book book = mainBook();
  print('Step 4: available? ${book.isAvailable}');
  book.borrow();
  print('Step 4: after borrow? ${book.isAvailable}');
  book.giveBack();
  print('Step 4: after return? ${book.isAvailable}');

  List<LibraryItem> items = [book, mainMagazine(), mainDvd()];
  for (var item in items) {
    print('Step 4: ${item.runtimeType} borrowable? ${item is Borrowable}');
  }
}

void step5() {
  print('--- Step 5 ---');
  Book book = mainBook();
  int ok = 0;
  for (int i = 0; i < renewAttempts; i++) {
    if (book.renew(renewLimit)) {
      ok++;
    }
  }

  print('Step 5: renewed $ok of $renewAttempts attempts (limit $renewLimit)');
  print('Step 5: renew once more? ${book.renew(renewLimit)}');
  print('Step 5: dvd can renew too? ${mainDvd().renew(1)}');
}

void step6() {
  print('--- Step 6 ---');
  MemberType type = MemberType.values[seed % 3];
  int fee = mainBook().lateFee(daysLate);

  print('Step 6: member type = ${type.name} (index ${type.index})');
  print('Step 6: max loans = ${type.maxLoans}');
  print('Step 6: book fee $fee -> ${type.applyDiscount(fee)} after discount');
}

void step7() {
  print('--- Step 7 ---');
  MemberType type = MemberType.values[seed % 3];
  int fee = mainBook().lateFee(daysLate);
  int discountedFee = type.applyDiscount(fee);

  List<LibraryItem> shelf = [mainBook(), mainMagazine(), mainDvd()];

  print('Step 7: ${discountedFee.rs}');
  print('Step 7: initials of "${titles[u]}" = ${titles[u].initials}');
  print('Step 7: shelf fee for $daysLate days = ${shelf.totalLateFee(daysLate).rs}');
}
void step8() {
  print('--- Step 8 ---');
  Fine f1 = Fine(mainBook().lateFee(daysLate));
  Fine f2 = Fine(mainMagazine().lateFee(daysLate));

  print('Step 8: $f1 + $f2 = ${f1 + f2}');
  print('Step 8: first bigger? ${f1 > f2}');
  print('Step 8: equal copies? ${f1 == Fine(f1.amount)}');

  var fineSet = {f1, Fine(f1.amount), f2};
  print('Step 8: set size = ${fineSet.length}');
}

void step9() {
  print('--- Step 9 ---');
  LibraryItem.created = 0;
  buildShelf();
  List<LibraryItem> shelf = buildShelf();

  print('Step 9: items created = ${LibraryItem.created}');
  print('Step 9: capped fee = ${LibraryItem.capFee(shelf.first.lateFee(daysBig))} (cap $feeCap)');
  print('Step 9: const copies identical? ${identical(const Fine(10), const Fine(10))}');
  print('Step 9: new copies identical? ${identical(Fine(10), Fine(10))}');
}
void step10() {
  print('--- Step 10 ---');
  List<LibraryItem> shelf = buildShelf();
  Member member = Member('S$seed', MemberType.values[seed % 3]);

  Fine total = shelf.fold(
    const Fine(0),
    (sum, item) => sum + member.feeFor(item, daysLate),
  );

  int bCount = shelf.whereType<Borrowable>().length;
  int rCount = shelf.whereType<Renewable>().length;

  print('Step 10: ${shelf.length} items, $bCount borrowable, $rCount renewable');
  print('Step 10: ${member.name} (${member.type.name}) owes $total');
  print('Step 10: over the cap? ${total > Fine(feeCap)}');
}