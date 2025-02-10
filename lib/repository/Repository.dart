import 'dart:collection';

class Repository<T> {
  // Skapar en Map för att lagra objekt där nyckeln är ett unikt ID
  final Map<int, T> _items = {};

  // Hämtar alla objekt som en lista
  List<T> get items => _items.values.toList();

  // Lägger till ett objekt i repositoryt med ett unikt ID
  void add(int id, T item) {
    _items[id] = item;
  }

  // Hämtar alla objekt som en oändringsbar lista
  List<T> getAll() {
    return UnmodifiableListView(_items.values.toList());
  }

  // Hämtar ett objekt baserat på ID, returnerar null om det inte hittas
  T? getById(int id) {
    return _items[id];
  }

  // Uppdaterar ett objekt i repositoryt om ID finns
  void update(int id, T item) {
    if (_items.containsKey(id)) {
      _items[id] = item;
    } else {
      throw Exception("Inget objekt hittades med ID $id");
    }
  }

  // Tar bort ett objekt från repositoryt om ID finns
  void delete(int id) {
    if (_items.containsKey(id)) {
      _items.remove(id);
    } else {
      throw Exception("Inget objekt hittades med ID $id");
    }
  }
}
