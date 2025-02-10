import 'dart:io';
import 'package:firstapp/util/Input.dart';
import 'package:firstapp/util/MenuUtil.dart';
import '../model/Vehicle.dart';
import '../repository/VehicleRepo.dart';
import '../model/Person.dart';
import '../repository/PersonRepo.dart';

// Klass för att hantera fordon via kommandoradsgränssnitt
class VehicleCli {
  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  // Huvudmeny för att hantera fordon
  Future<void> manageVehicles(
      VehicleRepo vehicleRepo, PersonRepo personRepo) async {
    bool back = false;

    while (!back) {
      print("\nDu har valt att hantera fordon. Vad vill du göra?");
      menuUtil.printVehicleMenu(); // Skriver ut menyn
      var input = userInput.getUserInput();

      if (await userVehicleChoice(input, vehicleRepo, personRepo)) {
        break; // Avslutar loopen om "5" väljs
      }
    }
  }

  // Hanterar användarens val från menyn
  Future<bool> userVehicleChoice(
      String? userInput, VehicleRepo vehicleRepo, PersonRepo personRepo) async {
    switch (userInput) {
      case "1":
        await addVehicle(vehicleRepo, personRepo);
        return false;
      case "2":
        viewAllVehicles(vehicleRepo);
        return false;
      case "3":
        updateVehicle(vehicleRepo, personRepo);
        return false;
      case "4":
        deleteVehicle(vehicleRepo);
        return false;
      case "5":
        return true; // Gå tillbaka till huvudmenyn
      default:
        print("Ogiltigt alternativ, försök igen.");
        return false;
    }
  }

  // Funktion för att lägga till ett nytt fordon
  Future<void> addVehicle(
      VehicleRepo vehicleRepo, PersonRepo personRepo) async {
    try {
      // Fråga användaren att ange registreringsnummer och ta bort eventuella blanksteg
      stdout.write("\nAnge registreringsnummer: ");
      String regNumber = userInput.getUserInput().trim();
      if (regNumber.isEmpty) {
        // Om fältet är tomt, kasta ett formatundantag
        throw FormatException("Registreringsnummer kan inte vara tomt.");
      }

      // Fråga användaren att ange typ av fordon
      stdout.write("Ange fordonstyp (Car, Motorcycle, Truck): ");
      String type = userInput.getUserInput().trim();
      if (type.isEmpty) {
        // Om fältet är tomt, kasta ett formatundantag
        throw FormatException("Fordonstyp kan inte vara tom.");
      }

      // Fråga användaren att ange ägarens ID och försök konvertera strängen till ett heltal
      stdout.write("Ange ägarens ID: ");
      String ownerInput = userInput.getUserInput().trim();
      int? ownerId = int.tryParse(ownerInput);
      if (ownerId == null) {
        // Om inmatningen inte kan konverteras till ett heltal, kasta ett formatundantag
        throw FormatException("Ogiltigt ID format.");
      }

      // Hämta ägaren från repository med angivet ID
      Person? owner = personRepo.getPersonById(ownerId);
      if (owner == null) {
        // Om ingen ägare hittades med ID:t, kasta ett allmänt undantag
        throw Exception("Ingen ägare hittades med ID $ownerId.");
      }

      // Beräkna ett nytt unikt ID för fordonet baserat på befintliga ID:n
      int newId = vehicleRepo.getAllVehicles().isEmpty
          ? 1
          : vehicleRepo
                  .getAllVehicles()
                  .map((v) => v.id)
                  .reduce((a, b) => a > b ? a : b) +
              1;

      // Skapa ett nytt fordon med det nya ID:t och de angivna attributen
      Vehicle newVehicle = Vehicle(
          id: newId, registreringsnummer: regNumber, type: type, owner: owner);
      vehicleRepo.addVehicle(newVehicle);

      // Informera användaren om att ett nytt fordon har lagts till
      print(
          "Nytt fordon tillagt: ID ${newVehicle.id}, Registreringsnummer: ${newVehicle.registreringsnummer}");
    } catch (e) {
      // Skriv ut felmeddelandet om något går fel under processen
      print("Fel: ${e.toString()}");
      return;
    }
  }

  // Visar alla fordon
  void viewAllVehicles(VehicleRepo vehicleRepo) {
    List<Vehicle> vehicles = vehicleRepo.getAllVehicles();
    if (vehicles.isEmpty) {
      print("Inga fordon hittades.");
    } else {
      print("\nLista över alla fordon:");
      for (var vehicle in vehicles) {
        print(
            'ID: ${vehicle.id}, Registreringsnummer: ${vehicle.registreringsnummer}, Typ: ${vehicle.type}, Ägare: ${vehicle.owner.namn}');
      }
    }
  }

  // Uppdaterar ett befintligt fordon
  void updateVehicle(VehicleRepo vehicleRepo, PersonRepo personRepo) {
    stdout.write("Ange ID på fordonet du vill uppdatera: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    // Hämtar det befintliga fordonet baserat på ID
    Vehicle? existingVehicle = vehicleRepo.getVehicleById(id);
    if (existingVehicle == null) {
      print("Inget fordon hittades med ID $id.");
      return;
    }

    // Ber användaren ange nytt registreringsnummer eller behålla det befintliga
    stdout.write(
        "Ange nytt registreringsnummer (${existingVehicle.registreringsnummer}): ");
    String newRegNumber = userInput.getUserInput();
    if (newRegNumber.isEmpty) {
      newRegNumber = existingVehicle.registreringsnummer;
    }

    // Ber användaren ange ny fordonstyp eller behålla den befintliga
    stdout.write("Ange ny typ (${existingVehicle.type}): ");
    String newType = userInput.getUserInput();
    if (newType.isEmpty) {
      newType = existingVehicle.type;
    }

    // Ber användaren ange ny ägare eller behålla den befintliga
    stdout.write("Ange ny ägarens ID (${existingVehicle.owner.id}): ");
    int? newOwnerId = int.tryParse(userInput.getUserInput());
    Person newOwner = existingVehicle.owner;

    if (newOwnerId != null) {
      Person? potentialNewOwner = personRepo.getPersonById(newOwnerId);
      if (potentialNewOwner != null) {
        newOwner = potentialNewOwner;
      }
    }

    // Skapar ett uppdaterat fordon och sparar det i databasen
    Vehicle updatedVehicle = Vehicle(
        id: existingVehicle.id,
        registreringsnummer: newRegNumber,
        type: newType,
        owner: newOwner);
    vehicleRepo.updateVehicle(id, updatedVehicle);
    print("Fordon uppdaterat.");
  }

  // Tar bort ett fordon
  void deleteVehicle(VehicleRepo vehicleRepo) {
    stdout.write("Ange ID på fordonet du vill ta bort: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    // Kontrollera om fordonet existerar innan borttagning
    if (vehicleRepo.getVehicleById(id) == null) {
      print("Inget fordon hittades med ID $id.");
      return;
    }

    // Tar bort fordonet från databasen
    vehicleRepo.deleteVehicle(id);
    print("Fordon borttaget.");
  }
}
