import '../model/Parking.dart';
import '../model/Vehicle.dart';
import '../model/ParkingSpace.dart';
import '../model/Person.dart';
import './Repository.dart';

class ParkingRepo extends Repository<Parking> {
  static final ParkingRepo _instance = ParkingRepo._internal();

  ParkingRepo._internal();

  static ParkingRepo get instance => _instance;

  // Existing methods...
  void addParking(Parking parking) {
    add(parking.id, parking);
  }

  List<Parking> getAllParkings() {
    return getAll();
  }

  Parking? getParkingById(int id) {
    return getById(id);
  }

  void updateParking(int id, Parking parking) {
    update(id, parking);
  }

  void deleteParking(int id) {
    delete(id);
  }

  List<Parking> findByVehicleId(int vehicleId) {
    return items.where((parking) => parking.vehicle.id == vehicleId).toList();
  }
}