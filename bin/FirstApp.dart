import 'dart:io';
import 'package:firstapp/repository/PersonRepo.dart';
import 'package:firstapp/util/Input.dart';
import 'package:firstapp/util/MenuUtil.dart';

import 'package:firstapp/model/Parking.dart';
import 'package:firstapp/repository/ParkingRepo.dart';
import 'package:firstapp/model/Vehicle.dart';
import 'package:firstapp/repository/VehicleRepo.dart';
import 'package:firstapp/model/ParkingSpace.dart';
import 'package:firstapp/repository/ParkingSpaceRepo.dart';
import 'package:firstapp/cli/ParkingCli.dart';
import 'package:firstapp/cli/ParkingSpaceCli.dart';
import 'package:firstapp/cli/PersonCli.dart';
import 'package:firstapp/cli/VehicleCli.dart';

void main() async {  // ✅ Make main() async
  // ✅ Initialize repositories
  VehicleRepo vehicleRepo = VehicleRepo();
  PersonRepo personRepo = PersonRepo();
  ParkingSpaceRepo parkingSpaceRepo = ParkingSpaceRepo();
  ParkingRepo parkingRepo = ParkingRepo();

  // ✅ Initialize CLI managers
  PersonCli personCli = PersonCli();
  VehicleCli vehicleCli = VehicleCli();
  ParkingSpaceCli parkingSpaceCli = ParkingSpaceCli();
  ParkingCli parkingCli = ParkingCli();

  Input userInput = Input();
  MenuUtil menuUtil = MenuUtil();

  bool back = false;
  while (!back) {
    print("\nVälkommen till Parkeringsappen");
    print("Vad vill du hantera?");
    menuUtil.printMainMenu();
    var input = userInput.getUserInput();
    back = await userChoice(input, personRepo, vehicleRepo, parkingSpaceRepo, parkingRepo, personCli, vehicleCli, parkingSpaceCli, parkingCli);
  }
}

// ✅ Now `managePersons()` and all CLI functions are properly awaited
Future<bool> userChoice(
    String? userInput,
    PersonRepo personRepo,
    VehicleRepo vehicleRepo,
    ParkingSpaceRepo parkingSpaceRepo,
    ParkingRepo parkingRepo,
    PersonCli personCli,
    VehicleCli vehicleCli,
    ParkingSpaceCli parkingSpaceCli,
    ParkingCli parkingCli) async {  // ✅ Make function async
  switch (userInput) {
    case "1":
      await personCli.managePersons(personRepo);  // ✅ Use await
      return false;
    case "2":
      await vehicleCli.manageVehicles(vehicleRepo, personRepo);  // ✅ Use await
      return false;
    case "3":
      await parkingSpaceCli.manageParkingSpaces(parkingSpaceRepo);  // ✅ Use await
      return false;
    case "4":
      await parkingCli.manageParking(parkingRepo, vehicleRepo, parkingSpaceRepo);  // ✅ Use await
      return false;
    case "5":
      print("Hejdå");
      return true;  // ✅ Properly exits without executing other menus
    default:
      print("Ogiltigt alternativ, försök igen.");
      return false;
  }
}
