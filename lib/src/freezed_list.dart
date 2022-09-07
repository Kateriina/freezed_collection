import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_collection/src/copy_on_write_list.dart';

part 'freezed_list.freezed.dart';

@Freezed(
    genericArgumentFactories: true,
    toJson: false,
    fromJson: false,
    copyWith: false,
    map: FreezedMapOptions.none)
class FreezedList<T> with _$FreezedList<T> implements Iterable<T> {
  const FreezedList._();

  factory FreezedList([Iterable iterable = const []]) =>
      FreezedList<T>.of(List<T>.from(iterable, growable: false));

  const factory FreezedList.of(List<T> list) = _FreezedList<T>;

  @override
  String toString() => list.toString();

  // region List
  /// Returns as an immutable list.
  ///
  /// Useful when producing or using APIs that need the [List] interface. This
  /// differs from [toList] where mutations are explicitly disallowed.
  List<T> asList() => List<T>.unmodifiable(list);

  // List.

  /// As [List.elementAt].
  T operator [](int index) => list[index];

  /// As [List.+].
  FreezedList<T> operator +(FreezedList<T> other) =>
      _FreezedList<T>(list + other.list);

  /// As [List.length].
  @override
  int get length => list.length;

  /// As [List.reversed].
  Iterable<T> get reversed => list.reversed;

  /// As [List.indexOf].
  int indexOf(T element, [int start = 0]) => list.indexOf(element, start);

  /// As [List.lastIndexOf].
  int lastIndexOf(T element, [int? start]) => list.lastIndexOf(element, start);

  /// As [List.indexWhere].
  int indexWhere(bool Function(T) test, [int start = 0]) =>
      list.indexWhere(test, start);

  /// As [List.lastIndexWhere].
  int lastIndexWhere(bool Function(T) test, [int? start]) =>
      list.lastIndexWhere(test, start);

  /// As [List.sublist] but returns a `FreezedList<T>`.
  FreezedList<T> sublist(int start, [int? end]) =>
      _FreezedList<T>(list.sublist(start, end));

  /// As [List.getRange].
  Iterable<T> getRange(int start, int end) => list.getRange(start, end);

  /// As [List.asMap].
  Map<int, T> asMap() => list.asMap();

  // endregion

  //region Iterable
  @override
  Iterator<T> get iterator => list.iterator;

  @override
  Iterable<E> map<E>(E Function(T) f) => list.map(f);

  @override
  Iterable<T> where(bool Function(T) test) => list.where(test);

  @override
  Iterable<E> whereType<E>() => list.whereType<E>();

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) => list.expand(f);

  @override
  bool contains(Object? element) => list.contains(element);

  @override
  void forEach(void Function(T) f) => list.forEach(f);

  @override
  T reduce(T Function(T, T) combine) => list.reduce(combine);

  @override
  E fold<E>(E initialValue, E Function(E, T) combine) =>
      list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => list.followedBy(other);

  @override
  bool every(bool Function(T) test) => list.every(test);

  @override
  String join([String separator = '']) => list.join(separator);

  @override
  bool any(bool Function(T) test) => list.any(test);

  /// As [Iterable.toList].
  ///
  /// Note that the implementation is efficient: it returns a copy-on-write
  /// wrapper around the data from this `FreezedList`. So, if no mutations are
  /// made to the result, no copy is made.
  ///
  /// This allows efficient use of APIs that ask for a mutable collection
  /// but don't actually mutate it.
  @override
  List<T> toList({bool growable = true}) => CopyOnWriteList<T>(list, growable);

  @override
  Set<T> toSet() => list.toSet();

  @override
  bool get isEmpty => list.isEmpty;

  @override
  bool get isNotEmpty => list.isNotEmpty;

  @override
  Iterable<T> take(int n) => list.take(n);

  @override
  Iterable<T> takeWhile(bool Function(T) test) => list.takeWhile(test);

  @override
  Iterable<T> skip(int n) => list.skip(n);

  @override
  Iterable<T> skipWhile(bool Function(T) test) => list.skipWhile(test);

  @override
  T get first => list.first;

  @override
  T get last => list.last;

  @override
  T get single => list.single;

  @override
  T firstWhere(bool Function(T) test, {T Function()? orElse}) =>
      list.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(bool Function(T) test, {T Function()? orElse}) =>
      list.lastWhere(test, orElse: orElse);

  @override
  T singleWhere(bool Function(T) test, {T Function()? orElse}) =>
      list.singleWhere(test, orElse: orElse);

  @override
  T elementAt(int index) => list.elementAt(index);

  @override
  Iterable<E> cast<E>() => Iterable.castFrom<T, E>(list);

  //endregion

  factory FreezedList.fromJson(
          List<dynamic> json, T Function(Object?) fromJsonT) =>
      FreezedList(json.map(fromJsonT).toList());

  List<dynamic> toJson() => list.map((e) => e).toList();

  @JsonKey(ignore: true)
  $FreezedListCopyWith<T, FreezedList<T>> get copyWith =>
      $FreezedListCopyWith<T, FreezedList<T>>(this, _$identity);
}

class $FreezedListCopyWith<T, $Res> {
  final FreezedList<T> __value;
  final $Res Function(FreezedList<T>) __then;

  $FreezedListCopyWith(this.__value, this.__then);

  FreezedList<T> get _value => __value;

  $Res call([Object? list = freezed]) {
    return __then(
        FreezedList<T>(list == freezed ? _value.list : list as List<T>));
  }

  /// Replace element according to what() with newElement.
  $Res replaceFirstWhere(T newElement, bool Function(T element) test) {
    final index = _value.list.indexWhere((element) => test(element));
    if (-1 != index) {
      var newList = _value.list.toList();
      newList[index] = newElement;
      return __then(FreezedList<T>(newList));
    } else {
      return __then(FreezedList<T>(_value.list));
    }
  }

  ///Removes first object from this list that satisfy the provided test condition.
  $Res removeFirstWhere(bool Function(T element) test) {
    final index = _value.list.indexWhere((element) => test(element));
    if (-1 != index) {
      var newList = _value.list.toList();
      newList.removeAt(index);
      return __then(FreezedList<T>(newList));
    } else {
      return __then(FreezedList<T>(_value.list));
    }
  }

  $Res set(int index, T element) {
    var newList = _value.list.toList();
    newList[index] = element;
    return __then(FreezedList<T>(newList));
  }

  /// Adds [value] to the end of this list,
  /// extending the length by one.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.add(4);
  /// print(numbers); // [1, 2, 3, 4]
  /// ```
  $Res add(T value) {
    var newList = _value.list.toList();
    newList.add(value);
    return __then(FreezedList<T>(newList));
  }

  /// Appends all objects of [iterable] to the end of this list.
  ///
  /// Extends the length of the list by the number of objects in [iterable].
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.addAll([4, 5, 6]);
  /// print(numbers); // [1, 2, 3, 4, 5, 6]
  /// ```
  $Res addAll(Iterable<T> iterable) {
    var newList = _value.list.toList();
    newList.addAll(iterable);
    return __then(FreezedList<T>(newList));
  }

  /// Removes all objects from this list; the length of the list becomes zero.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.clear();
  /// print(numbers.length); // 0
  /// print(numbers); // []
  /// ```
  $Res clear() {
    return __then(FreezedList<T>([]));
  }

  /// Overwrites a range of elements with [fillValue].
  ///
  /// Sets the positions greater than or equal to [start] and less than [end],
  /// to [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// If the element type is not nullable, the [fillValue] must be provided and
  /// must be non-`null`.
  ///
  /// Example:
  /// ```dart
  /// final words = List.filled(5, 'old');
  /// print(words); // [old, old, old, old, old]
  /// words.fillRange(1, 3, 'new');
  /// print(words); // [old, new, new, old, old]
  /// ```
  $Res fillRange(int start, int end, [T? fillValue]) {
    var newList = _value.list.toList();
    newList.fillRange(start, end, fillValue);
    return __then(FreezedList<T>(newList));
  }

  /// The first element of the list.
  ///
  /// The list must be non-empty when accessing its first element.
  ///
  /// The first element of a list can be modified, unlike an [Iterable].
  /// A `list.setFirst` is equivalent to `list[0]`,
  /// both for getting and setting the value.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// print(numbers.setFirst); // 1
  /// numbers.setFirst = 10;
  /// print(numbers.setFirst); // 10
  /// numbers.clear();
  /// numbers.setFirst; // Throws.
  /// ```
  $Res setFirst(T value) {
    var newList = _value.list.toList();
    newList.first = value;
    return __then(FreezedList<T>(newList));
  }

  /// Inserts [element] at position [index] in this list.
  ///
  /// This increases the length of the list by one and shifts all objects
  /// at or after the index towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4];
  /// const index = 2;
  /// numbers.insert(index, 10);
  /// print(numbers); // [1, 2, 10, 3, 4]
  /// ```
  $Res insert(int index, T element) {
    var newList = _value.list.toList();
    newList.insert(index, element);
    return __then(FreezedList<T>(newList));
  }

  /// Inserts all objects of [iterable] at position [index] in this list.
  ///
  /// This increases the length of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4];
  /// final insertItems = [10, 11];
  /// numbers.insertAll(2, insertItems);
  /// print(numbers); // [1, 2, 10, 11, 3, 4]
  /// ```
  $Res insertAll(int index, Iterable<T> iterable) {
    var newList = _value.list.toList();
    newList.insertAll(index, iterable);
    return __then(FreezedList<T>(newList));
  }

  /// The last element of the list.
  ///
  /// The list must be non-empty when accessing its last element.
  ///
  /// The last element of a list can be modified, unlike an [Iterable].
  /// A `list.setLast` is equivalent to `theList[theList.length - 1]`,
  /// both for getting and setting the value.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// print(numbers.setLast); // 3
  /// numbers.setLast = 10;
  /// print(numbers.setLast); // 10
  /// numbers.clear();
  /// numbers.setLast; // Throws.
  /// ```
  $Res setLast(T value) {
    var newList = _value.list.toList();
    newList.last = value;
    return __then(FreezedList<T>(newList));
  }

  /// Setting the `setLength` changes the number of elements in the list.
  ///
  /// The list must be growable.
  /// If [newLength] is greater than current length,
  /// new entries are initialized to `null`,
  /// so [newLength] must not be greater than the current length
  /// if the element type [E] is non-nullable.
  ///
  /// ```dart
  /// final maybeNumbers = <int?>[1, null, 3];
  /// maybeNumbers.setLength = 5;
  /// print(maybeNumbers); // [1, null, 3, null, null]
  /// maybeNumbers.setLength = 2;
  /// print(maybeNumbers); // [1, null]
  ///
  /// final numbers = <int>[1, 2, 3];
  /// numbers.setLength = 1;
  /// print(numbers); // [1]
  /// numbers.setLength = 5; // Throws, cannot add `null`s.
  /// ```
  $Res setLength(int newLength) {
    var newList = _value.list.toList();
    newList.length = newLength;
    return __then(FreezedList<T>(newList));
  }

  /// Removes the first occurrence of [value] from this list.
  ///
  /// Returns true if [value] was in the list, false otherwise.
  /// The list must be growable.
  ///
  /// ```dart
  /// final parts = <String>['head', 'shoulders', 'knees', 'toes'];
  /// final retVal = parts.remove('head'); // true
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  /// The method has no effect if [value] was not in the list.
  /// ```dart
  /// final parts = <String>['shoulders', 'knees', 'toes'];
  /// // Note: 'head' has already been removed.
  /// final retVal = parts.remove('head'); // false
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  $Res remove(Object? value) {
    var newList = _value.list.toList();
    newList.remove(value);
    return __then(FreezedList<T>(newList));
  }

  /// Removes the object at position [index] from this list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed value.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  /// The list must be growable.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeAt(2); // knees
  /// print(parts); // [head, shoulder, toes]
  /// ```
  $Res removeAt(int index) {
    var newList = _value.list.toList();
    newList.removeAt(index);
    return __then(FreezedList<T>(newList));
  }

  /// Removes and returns the first object in this list.
  ///
  /// The list must be growable and non-empty.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeFirst(); // toes
  /// print(parts); // [shoulder, knees, toes]
  /// ```
  $Res removeFirst() {
    var newList = _value.list.toList();
    newList.removeAt(0);
    return __then(FreezedList<T>(newList));
  }

  /// Removes and returns the last object in this list.
  ///
  /// The list must be growable and non-empty.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeLast(); // toes
  /// print(parts); // [head, shoulder, knees]
  /// ```
  $Res removeLast() {
    var newList = _value.list.toList();
    newList.removeLast();
    return __then(FreezedList<T>(newList));
  }

  /// Removes a range of elements from the list.
  ///
  /// Removes the elements with positions greater than or equal to [start]
  /// and less than [end], from the list.
  /// This reduces the list's length by `end - start`.
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The list must be growable.
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.removeRange(1, 4);
  /// print(numbers); // [1, 5]
  /// ```
  $Res removeRange(int start, int end) {
    var newList = _value.list.toList();
    newList.removeRange(start, end);
    return __then(FreezedList<T>(newList));
  }

  /// Removes all objects from this list that satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.removeWhere((item) => item.length == 3);
  /// print(numbers); // [three, four]
  /// ```
  /// The list must be growable.
  $Res removeWhere(bool Function(T element) test) {
    var newList = _value.list.toList();
    newList.removeWhere(test);
    return __then(FreezedList<T>(newList));
  }

  /// Replaces a range of elements with the elements of [replacements].
  ///
  /// Removes the objects in the range from [start] to [end],
  /// then inserts the elements of [replacements] at [start].
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// final replacements = [6, 7];
  /// numbers.replaceRange(1, 4, replacements);
  /// print(numbers); // [1, 6, 7, 5]
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The operation `list.replaceRange(start, end, replacements)`
  /// is roughly equivalent to:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.removeRange(1, 4);
  /// final replacements = [6, 7];
  /// numbers.insertAll(1, replacements);
  /// print(numbers); // [1, 6, 7, 5]
  /// ```
  /// but may be more efficient.
  ///
  /// The list must be growable.
  /// This method does not work on fixed-length lists, even when [replacements]
  /// has the same number of elements as the replaced range. In that case use
  /// [setRange] instead.
  $Res replaceRange(int start, int end, Iterable<T> replacements) {
    var newList = _value.list.toList();
    newList.replaceRange(start, end, replacements);
    return __then(FreezedList<T>(newList));
  }

  /// Removes all objects from this list that fail to satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.retainWhere((item) => item.length == 3);
  /// print(numbers); // [one, two]
  /// ```
  /// The list must be growable.
  $Res retainWhere(bool Function(T element) test) {
    var newList = _value.list.toList();
    newList.retainWhere(test);
    return __then(FreezedList<T>(newList));
  }

  /// Overwrites elements with the objects of [iterable].
  ///
  /// The elements of [iterable] are written into this list,
  /// starting at position [index].
  /// This operation does not increase the length of the list.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// If `iterable` is based on this list, its values may change _during_ the
  /// `setAll` operation.
  /// ```dart
  /// final list = <String>['a', 'b', 'c', 'd'];
  /// list.setAll(1, ['bee', 'sea']);
  /// print(list); // [a, bee, sea, d]
  /// ```
  $Res setAll(int index, Iterable<T> iterable) {
    var newList = _value.list.toList();
    newList.setAll(index, iterable);
    return __then(FreezedList<T>(newList));
  }

  /// Writes some elements of [iterable] into a range of this list.
  ///
  /// Copies the objects of [iterable], skipping [skipCount] objects first,
  /// into the range from [start], inclusive, to [end], exclusive, of this list.
  /// ```dart
  /// final list1 = <int>[1, 2, 3, 4];
  /// final list2 = <int>[5, 6, 7, 8, 9];
  /// // Copies the 4th and 5th items in list2 as the 2nd and 3rd items
  /// // of list1.
  /// const skipCount = 3;
  /// list1.setRange(1, 3, list2, skipCount);
  /// print(list1); // [1, 8, 9, 4]
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from `start`
  /// to `end` after skipping [skipCount] objects.
  ///
  /// If `iterable` is this list, the operation correctly copies the elements
  /// originally in the range from `skipCount` to `skipCount + (end - start)` to
  /// the range `start` to `end`, even if the two ranges overlap.
  ///
  /// If `iterable` depends on this list in some other way, no guarantees are
  /// made.
  $Res setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    var newList = _value.list.toList();
    newList.setRange(start, end, iterable, skipCount);
    return __then(FreezedList<T>(newList));
  }

  /// Shuffles the elements of this list randomly.
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.shuffle();
  /// print(numbers); // [1, 3, 4, 5, 2] OR some other random result.
  /// ```
  $Res shuffle([Random? random]) {
    var newList = _value.list.toList();
    newList.shuffle(random);
    return __then(FreezedList<T>(newList));
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers); // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// numbers.sort();
  /// print(numbers); // [-11, 0, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  $Res sort([int Function(T a, T b)? compare]) {
    var newList = _value.list.toList();
    newList.sort(compare);
    return __then(FreezedList<T>(newList));
  }
}
