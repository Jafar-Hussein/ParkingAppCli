import 'dart:io';
import '../model/Person.dart';
import '../repository/PersonRepo.dart';

Future<void> managePersons(PersonRepo personRepo) async {
  bool back = false;
  while (!back) {
    print("Du har valt att hantera personer. Vad vill du göra?");
    printMenu();
    var input = stdin.readLineSync();
    back = await userChoice(input, personRepo);
  }
}

Future<bool> userChoice(var userInput, PersonRepo personRepo) async {
  switch (userInput) {
    case "1":
      await addPerson(personRepo);
      return false;
    case "2":
      await viewAllPersons(personRepo);
      return false;
    case "3":
      await updatePerson(personRepo);
      return false;
    case "4":
      await deletePerson(personRepo);
      return false;
    case "5":
      return true; // Gå tillbaka till huvudmenyn
    default:
      print("Ogiltigt alternativ, försök igen.");
      return false;
  }
}

deletePerson(PersonRepo personRepo) async {
  await viewAllPersons(personRepo);
  stdout.write('\nAnge id för att ta bort');

  String? idInput = stdin.readLineSync();
  // konverterar idInput till int variabel
  int? id = int.tryParse(idInput ?? '');
  if (id != null) {
    await personRepo.deleteById(id);
  } else {
    print("Ogiltigt alternativ, försök igen.");
  }
}

updatePerson(PersonRepo personRepo) async {
  await viewAllPersons(personRepo);
  stdout.write('\nAnge id för att uppdatera: ');
  String? idInput = stdin.readLineSync();
  int? id = int.tryParse(idInput ?? '');

  if (id == null) {
    print("Ogiltigt id, försök igen.");
    return;
  }

  // Fetch the person's information by ID
  var currentPerson = await personRepo.getById(id);
  if (currentPerson == null) {
    print('Ingen person hittades med id $id');
    return;
  }

  print("Nuvarande detaljer:");
  print("Namn: ${currentPerson.namn}");
  print("Personnummer: ${currentPerson.personnummer}");

  // Get new person information
  stdout.write('Ange nytt namn (lämna tom om du vill behålla samma namn): ');
  String? newName = stdin.readLineSync();
  stdout.write(
      'Ange nytt personnummer (lämna tom om du vill behålla samma personnummer): ');
  String? newPersonnummer = stdin.readLineSync();

  newName = (newName?.isEmpty ?? true) ? currentPerson.namn : newName;
  newPersonnummer = (newPersonnummer?.isEmpty ?? true)
      ? currentPerson.personnummer
      : newPersonnummer;

  Person updatedPerson = Person(
      id: currentPerson.id, // Keep the same ID
      namn: newName!,
      personnummer: newPersonnummer!);

  await personRepo.updatePerson(updatedPerson);
  print('Person updaterades.');
}

viewAllPersons(PersonRepo personRepo) async {
  List<Person> persons = await personRepo.getAll();
  persons.forEach((person) {
    print(
        'ID: ${person.id}, Name: ${person.namn}, Personnummer: ${person.personnummer}');
  });
}

addPerson(PersonRepo personRepo) async {
  stdout.write("Ange namn ");
  String? name = stdin.readLineSync();
  stdout.write("Ange personnummer");
  String? personnummer = stdin.readLineSync();

  if (name != null && personnummer != null) {
    Person person = Person(id: 0, namn: name, personnummer: personnummer);
    await personRepo.addPerson(person);
  } else {
    print("Ogiltigt alternativ, försök igen.");
  }
}

void printMenu() {
  var options = [
    "1. Skapa person",
    "2. Visa alla Personer",
    "3. Updatera Person",
    "4. Ta bort Person",
    "5. Gå tillbaka till huvudmeny"
  ];

  for (var i = 0; i < options.length; i++) {
    print(options[i]);
  }
}
