import '../model/Person.dart';
import './Repository.dart';

class PersonRepo extends Repository<Person> {
  // Add a person
  void addPerson(Person person) {
    add(person.id, person);
  }

  // Get all persons
  List<Person> getAllPersons() {
    return getAll();
  }

  // Get person by ID
  Person? getPersonById(int id) {
    return getById(id);
  }

  // Update person
  void updatePerson(int id, Person person) {
    update(id, person);
  }

  // Delete person
  void deletePerson(int id) {
    delete(id);
  }
}
