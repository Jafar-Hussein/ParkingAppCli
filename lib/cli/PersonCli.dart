import 'dart:io';
import '../model/Person.dart';
import '../repository/PersonRepo.dart';

Future<void> managePersons(PersonRepo personRepo) async {
  bool back = false;

  while (!back) {
    print("\n👥 Du har valt att hantera personer. Vad vill du göra?");
    printMenu();
    var input = stdin.readLineSync();
    back = await userChoice(input, personRepo);
  }
}

Future<bool> userChoice(String? userInput, PersonRepo personRepo) async {
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
      return true;
    default:
      print("Ogiltigt alternativ, försök igen.");
      return false;
  }
}

Future<void> addPerson(PersonRepo personRepo) async {
  stdout.write("\nAnge namn: ");
  String? name = stdin.readLineSync();
  stdout.write("Ange personnummer: ");
  String? personnummer = stdin.readLineSync();

  if (name != null &&
      name.isNotEmpty &&
      personnummer != null &&
      personnummer.isNotEmpty) {
    // Generate a unique ID based on the highest existing ID
    int newId = personRepo.getAllPersons().isEmpty
        ? 1
        : personRepo
                .getAllPersons()
                .map((p) => p.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    Person newPerson =
        Person(id: newId, namn: name, personnummer: personnummer);
    personRepo.addPerson(newPerson);
    print("Ny person tillagd: ID ${newPerson.id}, Namn: ${newPerson.namn}");
  } else {
    print("Ogiltig information, försök igen.");
  }
}

Future<void> viewAllPersons(PersonRepo personRepo) async {
  List<Person> persons = personRepo.getAllPersons();
  if (persons.isEmpty) {
    print("Inga personer hittades.");
  } else {
    print("\nLista över alla personer:");
    for (var person in persons) {
      print(
          'ID: ${person.id}, Namn: ${person.namn}, Personnummer: ${person.personnummer}');
    }
  }
}

Future<void> updatePerson(PersonRepo personRepo) async {
  await viewAllPersons(personRepo);
  stdout.write("\nAnge ID för personen du vill uppdatera: ");
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print("Ogiltigt ID, försök igen.");
    return;
  }

  Person? currentPerson = personRepo.getPersonById(id);
  if (currentPerson == null) {
    print("Ingen person hittades med ID $id.");
    return;
  }

  print(
      "Nuvarande detaljer: Namn: ${currentPerson.namn},  Personnummer: ${currentPerson.personnummer}");

  stdout.write("Ange nytt namn (lämna tomt för att behålla): ");
  String? newName = stdin.readLineSync();
  stdout.write("Ange nytt personnummer (lämna tomt för att behålla): ");
  String? newPersonnummer = stdin.readLineSync();

  newName = (newName?.isEmpty ?? true) ? currentPerson.namn : newName;
  newPersonnummer = (newPersonnummer?.isEmpty ?? true)
      ? currentPerson.personnummer
      : newPersonnummer;

  Person updatedPerson = Person(
      id: currentPerson.id, namn: newName!, personnummer: newPersonnummer!);
  personRepo.updatePerson(id, updatedPerson);
  print("Person uppdaterad.");
}

Future<void> deletePerson(PersonRepo personRepo) async {
  await viewAllPersons(personRepo);
  stdout.write("\nAnge ID på personen du vill ta bort: ");
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print("Ogiltigt ID, försök igen.");
    return;
  }

  if (personRepo.getPersonById(id) == null) {
    print("Ingen person hittades med ID $id.");
    return;
  }

  personRepo.deletePerson(id);
  print("Person borttagen.");
}

void printMenu() {
  print("\n MENY:");
  print("1️ Skapa person");
  print("2️ Visa alla personer");
  print("3️ Uppdatera person");
  print("4️ Ta bort person");
  print("5️ Återgå till huvudmenyn");
}
