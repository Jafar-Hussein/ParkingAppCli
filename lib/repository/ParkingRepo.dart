import '../model/Parking.dart';
import '../model/Vehicle.dart';
import '../model/ParkingSpace.dart';
import '../model/Person.dart';
import './Repository.dart';

class ParkingRepo extends Repository<Parking> {
  // Add a parking entry
  void addParking(Parking parking) {
    add(parking.id, parking);
  }

  // Get all parking entries
  List<Parking> getAllParkings() {
    return getAll();
  }

  // Get parking by ID
  Parking? getParkingById(int id) {
    return getById(id);
  }

  // Update parking
  void updateParking(int id, Parking parking) {
    update(id, parking);
  }

  // Delete parking
  void deleteParking(int id) {
    delete(id);
  }

  // Find all parking by vehicle ID
  List<Parking> findByVehicleId(int vehicleId) {
    return items.where((parking) => parking.vehicle.id == vehicleId).toList();
  }
}
