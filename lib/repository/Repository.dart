import 'dart:collection';

class Repository<T> {
  final Map<int, T> _items = {}; // Store items using a Map with IDs as keys.

  List<T> get items => _items.values.toList(); // Return all items as a list.

  void add(int id, T item) {
    _items[id] = item; // Store item with its ID.
  }

  List<T> getAll() {
    return UnmodifiableListView(
        _items.values.toList()); // Convert Map values to a list.
  }

  T? getById(int id) {
    return _items[id]; // Return the item if found, otherwise return null.
  }

  void update(int id, T item) {
    if (_items.containsKey(id)) {
      _items[id] = item;
    } else {
      throw Exception("No item found with ID $id");
    }
  }

  void delete(int id) {
    if (_items.containsKey(id)) {
      _items.remove(id);
    } else {
      throw Exception("No item found with ID $id");
    }
  }
}
