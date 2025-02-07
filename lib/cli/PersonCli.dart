import 'dart:io';
import 'package:firstapp/util/Input.dart';
import 'package:firstapp/util/MenuUtil.dart';

import '../model/Person.dart';
import '../repository/PersonRepo.dart';

class PersonCli {
  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  Future<void> managePersons(PersonRepo personRepo) async {
    while (true) { // ✅ Loop will exit when "5" is pressed
      print("\nDu har valt att hantera personer. Vad vill du göra?");
      menuUtil.printPersonMenu();
      var input = userInput.getUserInput();
      
      if (await userChoice(input, personRepo)) {
        break; // ✅ Exits the loop when "5" is pressed
      }
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
        print("\nÅtergår till huvudmenyn...");
        return true; // ✅ This will break the loop in `managePersons()`
      default:
        print("Ogiltigt alternativ, försök igen.");
        return false;
    }
  }

  Future<void> addPerson(PersonRepo personRepo) async {
    stdout.write("\nAnge namn: ");
    String? name = userInput.getUserInput();
    stdout.write("Ange personnummer: ");
    String? personnummer = userInput.getUserInput();

    if (name != null &&
        name.isNotEmpty &&
        personnummer != null &&
        personnummer.isNotEmpty) {
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
    int? id = int.tryParse(userInput.getUserInput());
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
    String? newName = userInput.getUserInput();
    stdout.write("Ange nytt personnummer (lämna tomt för att behålla): ");
    String? newPersonnummer = userInput.getUserInput();

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
    int? id = int.tryParse(userInput.getUserInput());
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
}
