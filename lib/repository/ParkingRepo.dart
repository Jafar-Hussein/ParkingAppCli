import '../model/Parking.dart';
import '../model/Vehicle.dart';
import '../model/ParkingSpace.dart';
import '../model/Person.dart';
import './Repository.dart';

class ParkingRepo extends Repository<Parking> {
  static final ParkingRepo _instance = ParkingRepo._internal();
  ParkingRepo._internal();
  static ParkingRepo get instance => _instance;

  // Asynkron metod för att lägga till parkering
  Future<void> addParking(Parking parking) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulerar väntetid
    add(parking.id, parking);
  }

  // Hämtar alla parkeringar asynkront
  Future<List<Parking>> getAllParkings() async {
    await Future.delayed(Duration(milliseconds: 300));
    return getAll();
  }

  // Hämtar en specifik parkering baserat på ID
  Future<Parking?> getParkingById(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return getById(id);
  }

  // Uppdaterar en parkering asynkront
  Future<void> updateParking(int id, Parking parking) async {
    await Future.delayed(Duration(milliseconds: 300));
    update(id, parking);
  }

  // Tar bort en parkering asynkront
  Future<void> deleteParking(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    delete(id);
  }
}