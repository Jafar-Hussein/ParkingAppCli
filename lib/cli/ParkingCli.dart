import 'dart:io';
import 'package:firstapp/util/Input.dart';
import 'package:firstapp/util/MenuUtil.dart';

import '../model/Parking.dart';
import '../repository/ParkingRepo.dart';
import '../model/Vehicle.dart';
import '../repository/VehicleRepo.dart';
import '../model/ParkingSpace.dart';
import '../repository/ParkingSpaceRepo.dart';
import '../model/Person.dart';

// Klass för att hantera parkeringar via kommandoradsgränssnitt
class ParkingCli {
  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  // Huvudmeny för att hantera parkeringar
  Future<void> manageParking(ParkingRepo parkingRepo, VehicleRepo vehicleRepo,
      ParkingSpaceRepo parkingSpaceRepo) async {
    bool back = false;

    while (!back) {
      print("\nDu har valt att hantera parkeringar. Vad vill du göra?");
      menuUtil.printParkingMenu(); // Skriver ut parkeringsmenyn
      var input = userInput.getUserInput();
      // Hanterar användarens val
      back = await userParkingChoice(
          input, parkingRepo, vehicleRepo, parkingSpaceRepo);
    }
  }

  // Hanterar användarens val från menyn
  Future<bool> userParkingChoice(String? userInput, ParkingRepo parkingRepo,
      VehicleRepo vehicleRepo, ParkingSpaceRepo parkingSpaceRepo) async {
    switch (userInput) {
      case "1":
        await addParking(parkingRepo, vehicleRepo, parkingSpaceRepo);
        return false;
      case "2":
        await viewAllParkings(parkingRepo);
        return false;
      case "3":
        await updateParking(parkingRepo, vehicleRepo, parkingSpaceRepo);
        return false;
      case "4":
        await deleteParking(parkingRepo);
        return false;
      case "5":
        return true; // Gå tillbaka till huvudmenyn
      default:
        print("Ogiltigt alternativ, försök igen.");
        return false;
    }
  }

  Future<void> addParking(ParkingRepo parkingRepo, VehicleRepo vehicleRepo,
      ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("\nAnge fordonets ID: ");
    int? vehicleId = int.tryParse(userInput.getUserInput());
    if (vehicleId == null) {
      print("Ogiltigt ID. Försök igen.");
      return;
    }

    Vehicle? vehicle = await vehicleRepo.getVehicleById(vehicleId);
    if (vehicle == null) {
      print("Inget fordon hittades med ID $vehicleId");
      return;
    }

    stdout.write("Ange parkeringsplatsens ID: ");
    int? parkingSpaceId = int.tryParse(userInput.getUserInput());
    if (parkingSpaceId == null) {
      print("Ogiltigt ID. Försök igen.");
      return;
    }

    ParkingSpace? parkingSpace =
        await parkingSpaceRepo.getParkingSpaceById(parkingSpaceId);
    if (parkingSpace == null) {
      print("Ingen parkeringsplats hittades med ID $parkingSpaceId");
      return;
    }

    stdout.write("Ange starttid (yyyy-mm-dd hh:mm): ");
    DateTime startTime;
    try {
      startTime =
          DateTime.parse(userInput.getUserInput() ?? DateTime.now().toString());
    } catch (e) {
      print("Ogiltigt datumformat. Ange i formatet yyyy-mm-dd hh:mm.");
      return;
    }

    stdout.write(
        "Ange sluttid (yyyy-mm-dd hh:mm) eller lämna tom för pågående parkering: ");
    String? endTimeInput = userInput.getUserInput();
    DateTime? endTime;
    if (endTimeInput != null && endTimeInput.isNotEmpty) {
      try {
        endTime = DateTime.parse(endTimeInput);
      } catch (e) {
        print("Ogiltigt datumformat. Ange i formatet yyyy-mm-dd hh:mm.");
        return;
      }
    }

    int newId = (await parkingRepo.getAllParkings()).isEmpty
        ? 1
        : (await parkingRepo.getAllParkings())
                .map((p) => p.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    Parking newParking = Parking(
        id: newId,
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: startTime,
        endTime: endTime);

    double cost = newParking.parkingCost();
    newParking.price = cost;

    await parkingRepo.addParking(newParking);
    print(
        "Ny parkering tillagd: ID ${newParking.id}, Kostnad: ${cost.toStringAsFixed(2)} kr");
  }

// Visar alla parkeringar inklusive parkeringskostnad
  Future<void> viewAllParkings(ParkingRepo parkingRepo) async {
    List<Parking> parkings = await parkingRepo.getAllParkings();
    if (parkings.isEmpty) {
      print("Inga parkeringar hittades.");
    } else {
      print("\nLista över alla parkeringar:");
      for (var parking in parkings) {
        double cost = parking.parkingCost(); // Beräknar parkeringskostnaden
        print('Parking ID: ${parking.id}, '
            'Registreringsnummer: ${parking.vehicle.registreringsnummer}, '
            'Parkeringsplats: ${parking.parkingSpace.address}, '
            'Start: ${parking.startTime}, '
            'Slut: ${parking.endTime ?? "Pågående"}, '
            'Kostnad: ${cost.toStringAsFixed(2)} kr');
      }
    }
  }

  // Uppdaterar en befintlig parkering
  Future<void> updateParking(ParkingRepo parkingRepo, VehicleRepo vehicleRepo,
      ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("Ange ID på parkeringen du vill uppdatera: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    // Hämtar den befintliga parkeringen baserat på ID
    Parking? existingParking = await parkingRepo.getParkingById(id);
    if (existingParking == null) {
      print("Ingen parkering hittades med ID $id.");
      return;
    }

    stdout.write("Ange nytt fordonets ID (${existingParking.vehicle.id}): ");
    int? newVehicleId = int.tryParse(userInput.getUserInput());
    if (newVehicleId != null) {
      Vehicle? newVehicle = vehicleRepo.getById(newVehicleId);
      if (newVehicle != null) {
        existingParking.vehicle = newVehicle;
      }
    }

    stdout.write(
        "Ange ny parkeringsplatsens ID (${existingParking.parkingSpace.id}): ");
    int? newParkingSpaceId = int.tryParse(userInput.getUserInput());
    if (newParkingSpaceId != null) {
      ParkingSpace? newParkingSpace =
          parkingSpaceRepo.getById(newParkingSpaceId);
      if (newParkingSpace != null) {
        existingParking.parkingSpace = newParkingSpace;
      }
    }

    // Uppdaterar parkeringen i databasen
    parkingRepo.updateParking(id, existingParking);
    print("Parkering uppdaterad.");
  }

  // Tar bort en parkering
  Future<void> deleteParking(ParkingRepo parkingRepo) async {
    stdout.write("Ange ID på parkeringen du vill ta bort: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    // Kontrollera om parkeringen existerar innan borttagning
    if (parkingRepo.getParkingById(id) == null) {
      print("Ingen parkering hittades med ID $id.");
      return;
    }

    // Tar bort parkeringen från databasen
    parkingRepo.deleteParking(id);
    print("Parkering borttagen.");
  }
}
