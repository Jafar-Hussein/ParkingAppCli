import '../model/Vehicle.dart';
import './Repository.dart';

class VehicleRepo extends Repository<Vehicle> {
  static final VehicleRepo _instance = VehicleRepo._internal();

  VehicleRepo._internal();

  static VehicleRepo get instance => _instance;

  // Existing methods...
  void addVehicle(Vehicle vehicle) {
    add(vehicle.id, vehicle);
  }

  List<Vehicle> getAllVehicles() {
    return getAll();
  }

  Vehicle? getVehicleById(int id) {
    return getById(id);
  }

  void updateVehicle(int id, Vehicle vehicle) {
    update(id, vehicle);
  }

  void deleteVehicle(int id) {
    delete(id);
  }

  List<Vehicle> findByOwnerId(int ownerId) {
    return items.where((vehicle) => vehicle.owner.id == ownerId).toList();
  }
}

