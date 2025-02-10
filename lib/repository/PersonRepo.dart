import '../model/Person.dart';
import './Repository.dart';

class PersonRepo extends Repository<Person> {
  static final PersonRepo _instance = PersonRepo._internal();

  PersonRepo._internal();

  static PersonRepo get instance => _instance;

  // Existing methods...
  void addPerson(Person person) {
    add(person.id, person);
  }

  List<Person> getAllPersons() {
    return getAll();
  }

  Person? getPersonById(int id) {
    return getById(id);
  }

  void updatePerson(int id, Person person) {
    update(id, person);
  }

  void deletePerson(int id) {
    delete(id);
  }
}

