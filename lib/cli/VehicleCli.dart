import 'dart:io';
import 'package:firstapp/util/Input.dart';
import '../model/Vehicle.dart';
import '../repository/VehicleRepo.dart';
import '../model/Person.dart';
import '../repository/PersonRepo.dart';

class VehicleCli {
  Input userInput = Input();

  void manageVehicles(VehicleRepo vehicleRepo, PersonRepo personRepo) {
    bool back = false;

    while (!back) {
      print("\nDu har valt att hantera fordon. Vad vill du göra?");
      printVehicleMenu();
      var input = userInput.getUserInput();
      back = userVehicleChoice(input, vehicleRepo, personRepo);
    }
  }

  bool userVehicleChoice(String? userInput, VehicleRepo vehicleRepo, PersonRepo personRepo) {
    switch (userInput) {
      case "1":
        addVehicle(vehicleRepo, personRepo);
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
        return true; // Exit to the main menu
      default:
        print("Ogiltigt alternativ, försök igen.");
        return false;
    }
  }

  void addVehicle(VehicleRepo vehicleRepo, PersonRepo personRepo) {
    stdout.write("\nAnge registreringsnummer: ");
    String regNumber = userInput.getUserInput();
    if (regNumber.isEmpty) {
      print("Ogiltigt registreringsnummer. Försök igen.");
      return;
    }

    stdout.write("Ange fordonstyp (Car, Motorcycle, Truck): ");
    String type = userInput.getUserInput();
    if (type.isEmpty) {
      print("Ogiltig typ. Försök igen.");
      return;
    }

    stdout.write("Ange ägarens ID: ");
    int? ownerId = int.tryParse(userInput.getUserInput());
    if (ownerId == null) {
      print("Ogiltigt ID. Försök igen.");
      return;
    }

    Person? owner = personRepo.getPersonById(ownerId);
    if (owner == null) {
      print("Ingen ägare hittades med ID $ownerId.");
      return;
    }

    // Generate a unique ID
    int newId = vehicleRepo.getAllVehicles().isEmpty
        ? 1
        : vehicleRepo.getAllVehicles().map((v) => v.id).reduce((a, b) => a > b ? a : b) + 1;

    Vehicle newVehicle = Vehicle(id: newId, registreringsnummer: regNumber, type: type, owner: owner);
    vehicleRepo.addVehicle(newVehicle);
    print("Nytt fordon tillagt: ID ${newVehicle.id}, Registreringsnummer: ${newVehicle.registreringsnummer}");
  }

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

  void updateVehicle(VehicleRepo vehicleRepo, PersonRepo personRepo) {
    stdout.write("Ange ID på fordonet du vill uppdatera: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    Vehicle? existingVehicle = vehicleRepo.getVehicleById(id);
    if (existingVehicle == null) {
      print("Inget fordon hittades med ID $id.");
      return;
    }

    stdout.write("Ange nytt registreringsnummer (${existingVehicle.registreringsnummer}): ");
    String newRegNumber = userInput.getUserInput();
    if (newRegNumber.isEmpty) {
      newRegNumber = existingVehicle.registreringsnummer;
    }

    stdout.write("Ange ny typ (${existingVehicle.type}): ");
    String newType = userInput.getUserInput();
    if (newType.isEmpty) {
      newType = existingVehicle.type;
    }

    stdout.write("Ange ny ägarens ID (${existingVehicle.owner.id}): ");
    int? newOwnerId = int.tryParse(userInput.getUserInput());
    Person newOwner = existingVehicle.owner;

    if (newOwnerId != null) {
      Person? potentialNewOwner = personRepo.getPersonById(newOwnerId);
      if (potentialNewOwner != null) {
        newOwner = potentialNewOwner;
      }
    }

    Vehicle updatedVehicle = Vehicle(id: existingVehicle.id, registreringsnummer: newRegNumber, type: newType, owner: newOwner);
    vehicleRepo.updateVehicle(id, updatedVehicle);
    print("Fordon uppdaterat.");
  }

  void deleteVehicle(VehicleRepo vehicleRepo) {
    stdout.write("Ange ID på fordonet du vill ta bort: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    if (vehicleRepo.getVehicleById(id) == null) {
      print("Inget fordon hittades med ID $id.");
      return;
    }

    vehicleRepo.deleteVehicle(id);
    print("Fordon borttaget.");
  }

  void printVehicleMenu() {
    print("\nMENY:");
    print("1. Lägg till fordon");
    print("2. Visa alla fordon");
    print("3. Uppdatera fordon");
    print("4. Ta bort fordon");
    print("5. Återgå till huvudmenyn");
  }
}
