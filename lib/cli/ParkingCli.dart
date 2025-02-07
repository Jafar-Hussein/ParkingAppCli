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

class ParkingCli {
  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  Future<void> manageParking(ParkingRepo parkingRepo, VehicleRepo vehicleRepo,
      ParkingSpaceRepo parkingSpaceRepo) async {
    bool back = false;

    while (!back) {
      print("\nDu har valt att hantera parkeringar. Vad vill du göra?");
      menuUtil.printParkingMenu();
      var input = userInput.getUserInput();
      back = await userParkingChoice(
          input, parkingRepo, vehicleRepo, parkingSpaceRepo);
    }
  }

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
        return true; // Exit to the main menu
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

    Vehicle? vehicle = vehicleRepo.getById(vehicleId);
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

    ParkingSpace? parkingSpace = parkingSpaceRepo.getById(parkingSpaceId);
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
        "Ange sluttid (yyyy-mm-dd hh:mm) eller lämna tom för nuvarande parkeringar: ");
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

    int newId = parkingRepo.getAllParkings().isEmpty
        ? 1
        : parkingRepo
                .getAllParkings()
                .map((p) => p.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    Parking newParking = Parking(
        id: newId,
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: startTime,
        endTime: endTime);

    parkingRepo.addParking(newParking);
    print("Ny parkering tillagd: ID ${newParking.id}");
  }

  Future<void> viewAllParkings(ParkingRepo parkingRepo) async {
    List<Parking> parkings = parkingRepo.getAllParkings();
    if (parkings.isEmpty) {
      print("Inga parkeringar hittades.");
    } else {
      print("\nLista över alla parkeringar:");
      for (var parking in parkings) {
        print('Parking ID: ${parking.id}, '
            'Registreringsnummer: ${parking.vehicle.registreringsnummer}, '
            'Parkeringsplats: ${parking.parkingSpace.address}, '
            'Start: ${parking.startTime}, '
            'Slut: ${parking.endTime ?? "Pågående"}');
      }
    }
  }

  Future<void> updateParking(ParkingRepo parkingRepo, VehicleRepo vehicleRepo,
      ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("Ange ID på parkeringen du vill uppdatera: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    Parking? existingParking = parkingRepo.getParkingById(id);
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

    parkingRepo.updateParking(id, existingParking);
    print("Parkering uppdaterad.");
  }

  Future<void> deleteParking(ParkingRepo parkingRepo) async {
    stdout.write("Ange ID på parkeringen du vill ta bort: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    if (parkingRepo.getParkingById(id) == null) {
      print("Ingen parkering hittades med ID $id.");
      return;
    }

    parkingRepo.deleteParking(id);
    print("Parkering borttagen.");
  }
}
