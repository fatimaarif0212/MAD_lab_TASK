//step 1
/* Question: Why is item.pages a compile error even though the object really has pages?
 Answer: Dart checks code while compiling, not while running. Because item is declared as a LibraryItem, Dart only lets you use fields that LibraryItem has. Even though item is actually a Book in memory, the LibraryItem class doesn't have a pages field—so Dart stops you before the code can even run.
*/
//step 2
/* Question: What would happen to the output if you forgot @override and mistyped the method name as descibe()?
Answer: It would define a new method descibe() on the subclass. Calling describe() on an instance would execute the parent LibraryItem's describe() method, missing the subclass-specific extra details.
*/
//step 3
/* Question: Temporarily try LibraryItem('x', 2000). Read the error. Why can you not create an abstract class directly?
 Answer: Abstract classes are incomplete blueprints that can have methods without function bodies. Dart stops you from instantiating them so you never call missing method logic at runtime.
*/
//step 4
/* Question: You wrote all three method bodies yourself. What would extends Borrowable have given you for free, and why is that not what you wanted?
 Answer: Using extends gives concrete fields and default method implementations for code reuse. Using implements enforces an API contract without locking subclasses into a single parent class hierarchy.
*/
//step 5
/* Question: Book and Dvd need the same renew code but Magazine must not have it. Why is a mixin a better fit than putting renew in LibraryItem?
Answer: Putting renew in LibraryItem would give it to Magazine as well. A mixin lets you share concrete methods sideways between specific classes without polluting the whole base class tree.
*/
//step 6
/*Question: Why is MemberType.student safer than the string 'student'?
Answer: Enums are checked at compile time, preventing typos. Strings are not validated by the compiler and can contain undetected typos like 'studnt'.
*/
//step 7
/* Question: You could have written plain functions rs(int x). What do you gain by writing 72.rs instead?
Answer: Extension methods provide clean dot-notation syntax and autocomplete suggestions directly on instances.
*/
//step 8
/* Question: Delete your hashCode and run again. What happens to the set size, and why does Dart expect both == and hashCode together?
 Answer: Without overriding hashCode, sets place objects in different hash buckets using default object identities, treating duplicates as separate elements and making set size 3 instead of 2.
*/
//step 9
/* Question: Why can created be read as LibraryItem.created without making any object first?
Answer: Static members belong directly to the class definition rather than individual object instances.
*/
//Questions
/*Q1: What can a subclass using extends use for free that a class using implements has to write itself? 
Ans:When you use extends, your subclass inherits the actual working code all the variables, fields, and method bodies from the parent class for free. You don't have to rewrite any of it unless you want to change how it works.
When you use implements, you only copy the blueprint. The original code is completely ignored, forcing you to write every single field, getter, and method body yourself from scratch.*/
/*Q2:. Book and Dvd both use Renewable. When would you pick a mixin, and when an abstract parent class? 
Ans:Abstract parent class: Use when classes have an "is-a" relationship . It defines the main identity and shared core properties of a group.
Mixin: Use when classes have a "can-do" feature . It lets you share a specific capability sideways only with the classes that need it, without forcing it on others like Magazines.*/
/*Q3:Why must you override hashCode whenever you override ==?
Ans:Collections like Set and Map use hashCode first to find the right storage bucket, and then use == to check if the items inside that bucket are equal.
If you override == to say two objects are equal, but forget to override hashCode, Dart gives them different hash codes. The collection puts them into completely different buckets and fails to realize they are identical, causing duplicates and missing lookups.
*/
/*Q4:An extension method on String and a subclass of String both add behaviour. Why does Dart let you write the first one but not the second? 
Ans:Extension methods: They don't actually change or subclass the original class. They are just static helper functions wrapped in nice syntax ('text'.initials), which makes them lightweight and safe to add to any type.
Subclassing (extends String): Dart explicitly forbids subclassing String because String is an abstract interface backed by internal, platform-specific core implementations (like Web vs. VM strings). Direct subclassing would break string optimizations and system security across the Dart runtime.