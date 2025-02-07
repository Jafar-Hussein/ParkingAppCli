import 'dart:io';
import 'package:firstapp/util/Input.dart';
import 'package:firstapp/util/MenuUtil.dart';
import '../model/ParkingSpace.dart';
import '../repository/ParkingSpaceRepo.dart';

class ParkingSpaceCli {
  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  Future<void> manageParkingSpaces(ParkingSpaceRepo parkingSpaceRepo) async {
    bool back = false;

    while (!back) {
      print("\nDu har valt att hantera parkeringsplatser. Vad vill du göra?");
      menuUtil.printParkingSpaceMenu();
      var input = userInput.getUserInput();
      back = await userParkingSpaceChoice(input, parkingSpaceRepo);
    }
  }

  Future<bool> userParkingSpaceChoice(
      String? userInput, ParkingSpaceRepo parkingSpaceRepo) async {
    switch (userInput) {
      case "1":
        await addParkingSpace(parkingSpaceRepo);
        return false;
      case "2":
        await viewAllParkingSpaces(parkingSpaceRepo);
        return false;
      case "3":
        await updateParkingSpace(parkingSpaceRepo);
        return false;
      case "4":
        await deleteParkingSpace(parkingSpaceRepo);
        return false;
      case "5":
        return true; // Exit to the main menu
      default:
        print("Ogiltigt alternativ, försök igen.");
        return false;
    }
  }

  Future<void> addParkingSpace(ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("\nAnge adress för parkeringsplatsen: ");
    String address = userInput.getUserInput();
    if (address.isEmpty) {
      print("Ogiltig adress. Försök igen.");
      return;
    }

    stdout.write("Ange pris per timme: ");
    double? pricePerHour = double.tryParse(userInput.getUserInput());
    if (pricePerHour == null || pricePerHour <= 0) {
      print("Ogiltigt pris. Försök igen.");
      return;
    }

    // Generate a unique ID
    int newId = parkingSpaceRepo.getAllParkingSpaces().isEmpty
        ? 1
        : parkingSpaceRepo
                .getAllParkingSpaces()
                .map((p) => p.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    ParkingSpace newParkingSpace =
        ParkingSpace(id: newId, address: address, pricePerHour: pricePerHour);
    parkingSpaceRepo.addParkingSpace(newParkingSpace);
    print("Ny parkeringsplats tillagd: ID ${newParkingSpace.id}");
  }

  Future<void> viewAllParkingSpaces(ParkingSpaceRepo parkingSpaceRepo) async {
    List<ParkingSpace> parkingSpaces = parkingSpaceRepo.getAllParkingSpaces();
    if (parkingSpaces.isEmpty) {
      print("Inga parkeringsplatser hittades.");
    } else {
      print("\nLista över alla parkeringsplatser:");
      for (var space in parkingSpaces) {
        print(
            'ID: ${space.id}, Adress: ${space.address}, Pris per timme: ${space.pricePerHour}');
      }
    }
  }

  Future<void> updateParkingSpace(ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("Ange ID på parkeringsplatsen du vill uppdatera: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    ParkingSpace? existingSpace = parkingSpaceRepo.getParkingSpaceById(id);
    if (existingSpace == null) {
      print("Ingen parkeringsplats hittades med ID $id.");
      return;
    }

    stdout.write("Ange ny adress (${existingSpace.address}): ");
    String newAddress = userInput.getUserInput();
    if (newAddress.isEmpty) {
      newAddress = existingSpace.address;
    }

    stdout.write("Ange nytt pris per timme (${existingSpace.pricePerHour}): ");
    double? newPricePerHour = double.tryParse(userInput.getUserInput());
    if (newPricePerHour == null || newPricePerHour <= 0) {
      newPricePerHour = existingSpace.pricePerHour;
    }

    ParkingSpace updatedSpace = ParkingSpace(
        id: existingSpace.id,
        address: newAddress,
        pricePerHour: newPricePerHour);
    parkingSpaceRepo.updateParkingSpace(id, updatedSpace);
    print("Parkeringsplats uppdaterad.");
  }

  Future<void> deleteParkingSpace(ParkingSpaceRepo parkingSpaceRepo) async {
    stdout.write("Ange ID på parkeringsplatsen du vill ta bort: ");
    int? id = int.tryParse(userInput.getUserInput());
    if (id == null) {
      print("Ogiltigt ID.");
      return;
    }

    if (parkingSpaceRepo.getParkingSpaceById(id) == null) {
      print("Ingen parkeringsplats hittades med ID $id.");
      return;
    }

    parkingSpaceRepo.deleteParkingSpace(id);
    print("Parkeringsplats borttagen.");
  }
}
