import '../model/Vehicle.dart';
import './Repository.dart';

class VehicleRepo extends Repository<Vehicle> {
  static final VehicleRepo _instance = VehicleRepo._internal();
  VehicleRepo._internal();
  static VehicleRepo get instance => _instance;

  // Lägg till ett fordon asynkront
  Future<void> addVehicle(Vehicle vehicle) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulerad fördröjning
    add(vehicle.id, vehicle);
  }

  // Hämta alla fordon asynkront
  Future<List<Vehicle>> getAllVehicles() async {
    await Future.delayed(Duration(milliseconds: 300));
    return getAll();
  }

  // Hämta ett fordon baserat på ID asynkront
  Future<Vehicle?> getVehicleById(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return getById(id);
  }

  // Uppdatera ett fordon asynkront
  Future<void> updateVehicle(int id, Vehicle vehicle) async {
    await Future.delayed(Duration(milliseconds: 300));
    update(id, vehicle);
  }

  // Ta bort ett fordon asynkront
  Future<void> deleteVehicle(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    delete(id);
  }

  // Hitta alla fordon för en specifik ägare asynkront
  Future<List<Vehicle>> findByOwnerId(int ownerId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return items.where((vehicle) => vehicle.owner.id == ownerId).toList();
  }
}

