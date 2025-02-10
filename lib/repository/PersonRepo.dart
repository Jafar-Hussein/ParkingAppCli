import '../model/Person.dart';
import './Repository.dart';

class PersonRepo extends Repository<Person> {
  static final PersonRepo _instance = PersonRepo._internal();
  PersonRepo._internal();
  static PersonRepo get instance => _instance;

  // Lägg till en person asynkront
  Future<void> addPerson(Person person) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulerad fördröjning
    add(person.id, person);
  }

  // Hämta alla personer asynkront
  Future<List<Person>> getAllPersons() async {
    await Future.delayed(Duration(milliseconds: 300));
    return getAll();
  }

  // Hämta en person baserat på ID asynkront
  Future<Person?> getPersonById(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return getById(id);
  }

  // Uppdatera en person asynkront
  Future<void> updatePerson(int id, Person person) async {
    await Future.delayed(Duration(milliseconds: 300));
    update(id, person);
  }

  // Ta bort en person asynkront
  Future<void> deletePerson(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    delete(id);
  }
}

