import 'dart:io';
import '../lib/repository/PersonRepo.dart';
import '../lib/model/Person.dart';

void main() async {
  // runApp(const MyApp());
  var personRepo = PersonRepo();

  bool isRunning = true;

  while (isRunning) {
    print('\nChoose an option');
    print('1, Add person');
    print('2, Get all persons');
    print('3. Exit');

    var choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        print('enter name');
        String? name = stdin.readLineSync();
        print('Enter personnummer:');
        String? personnummer = stdin.readLineSync();

        if (name != null && personnummer != null) {
          var person = Person(id: 0, namn: name, personnummer: personnummer); //
          await personRepo.addPerson(person);
        } else {
          print('Invalid input.');
        }
        break;
      case '2':
        // Get all persons
        var persons = await personRepo.getAll();
        if (persons.isNotEmpty) {
          for (var person in persons) {
            print(
                'ID: ${person.id}, Name: ${person.namn}, Personnummer: ${person.personnummer}');
          }
        } else {
          print('No persons found.');
        }
        break;

      case '3':
        print('Goodbye');
        isRunning = false;
        break;

      default:
        print('Invalid choice. Please try again.');
    }
  }
}
