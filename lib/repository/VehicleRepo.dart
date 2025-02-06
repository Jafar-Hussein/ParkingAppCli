import '../model/Vehicle.dart';
import './Repository.dart';

class VehicleRepo extends Repository<Vehicle> {
  Map<int, Vehicle> vehicles = {};
  // Add a vehicle
  void addVehicle(Vehicle vehicle) {
    add(vehicle.id, vehicle); // Use vehicle's own ID when adding
  }

  // Get all vehicles
  List<Vehicle> getAllVehicles() {
    return getAll();
  }

  // Get vehicle by ID
 Vehicle? getVehicleById(int id) {
    return getById(id); // Use getById from Repository<T>
  }

  // Update vehicle
  void updateVehicle(int id, Vehicle vehicle) {
    update(id, vehicle);
  }

  // Delete vehicle
  void deleteVehicle(int id) {
    delete(id);
  }

  // Find vehicles by owner ID
  List<Vehicle> findByOwnerId(int ownerId) {
    return items.where((vehicle) => vehicle.owner.id == ownerId).toList();
  }
}
