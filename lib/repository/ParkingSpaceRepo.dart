import './Repository.dart';
import '../model/ParkingSpace.dart';

class ParkingSpaceRepo extends Repository<ParkingSpace> {
  static final ParkingSpaceRepo _instance = ParkingSpaceRepo._internal();
  ParkingSpaceRepo._internal();
  static ParkingSpaceRepo get instance => _instance;

  // Lägg till en parkeringsplats asynkront
  Future<void> addParkingSpace(ParkingSpace space) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulerad fördröjning
    add(space.id, space);
  }

  // Hämta alla parkeringsplatser asynkront
  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    await Future.delayed(Duration(milliseconds: 300));
    return getAll();
  }

  // Hämta en specifik parkeringsplats asynkront
  Future<ParkingSpace?> getParkingSpaceById(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return getById(id);
  }

  // Uppdatera en parkeringsplats asynkront
  Future<void> updateParkingSpace(int id, ParkingSpace space) async {
    await Future.delayed(Duration(milliseconds: 300));
    update(id, space);
  }

  // Ta bort en parkeringsplats asynkront
  Future<void> deleteParkingSpace(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    delete(id);
  }
}
