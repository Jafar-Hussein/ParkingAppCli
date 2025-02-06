import 'dart:io';
import '../lib/model/Parking.dart';
import '../lib/repository/ParkingRepo.dart';
import '../lib/model/Vehicle.dart';
import '../lib/repository/VehicleRepo.dart';
import '../lib/model/ParkingSpace.dart';
import '../lib/repository/ParkingSpaceRepo.dart';
import "../lib/model/Person.dart";
import "../lib/cli/ParkingCli.dart";

void main() {
  // Instantiate repositories
  VehicleRepo vehicleRepo = VehicleRepo();
  ParkingSpaceRepo parkingSpaceRepo = ParkingSpaceRepo();
  ParkingRepo parkingRepo = ParkingRepo();

  // Add test data
  vehicleRepo.addVehicle(Vehicle(
      id: 1,
      registreringsnummer: "ABC123",
      type: "Car",
      owner: Person(id: 1, namn: "John Doe", personnummer: "850322-1234")));
  vehicleRepo.addVehicle(Vehicle(
      id: 2,
      registreringsnummer: "XYZ789",
      type: "Motorcycle",
      owner: Person(id: 2, namn: "Jane Smith", personnummer: "900101-5678")));

  parkingSpaceRepo.addParkingSpace(
      ParkingSpace(id: 1, address: "123 Parking Lot", pricePerHour: 2.50));
  parkingSpaceRepo.addParkingSpace(
      ParkingSpace(id: 2, address: "456 Garage", pricePerHour: 3.75));

  // Auto-generate parking ID
  int newParkingId = parkingRepo.getAllParkings().isEmpty
      ? 1
      : parkingRepo
              .getAllParkings()
              .map((p) => p.id)
              .reduce((a, b) => a > b ? a : b) +
          1;

  // Fetch vehicle and parking space safely
  Vehicle? vehicle = vehicleRepo.getVehicleById(1);
  ParkingSpace? parkingSpace = parkingSpaceRepo.getParkingSpaceById(1);

  if (vehicle == null || parkingSpace == null) {
    print("Fel: Kunde inte hämta fordon eller parkeringsplats.");
    return;
  }

  // Add a parking entry manually
  Parking newParking = Parking(
    id: newParkingId,
    vehicle: vehicle,
    parkingSpace: parkingSpace,
    startTime: DateTime.now(),
    endTime: null, // No end time initially
  );

  // Add parking entry to repository
  parkingRepo.addParking(newParking);

  // Print the added parking entry
  print("\nNy parkering tillagd:");
  printParkingDetails(newParking);

  // Call the manageParking function
  manageParking(parkingRepo, vehicleRepo, parkingSpaceRepo);
}

// Function to print parking details including vehicle info
void printParkingDetails(Parking parking) {
  print('Parking ID: ${parking.id}, '
      'Vehicle: [Registreringsnummer: ${parking.vehicle.registreringsnummer}, '
      'Typ: ${parking.vehicle.type}, '
      'Ägare: ${parking.vehicle.owner.namn}], '
      'Parking Space: ${parking.parkingSpace.address}, '
      'Start Time: ${parking.startTime}, '
      'End Time: ${parking.endTime ?? "Pågående"}');
}
