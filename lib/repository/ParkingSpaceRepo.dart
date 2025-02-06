import './Repository.dart';
import '../model/ParkingSpace.dart';

class ParkingSpaceRepo extends Repository<ParkingSpace> {
  // Add a parking space
  void addParkingSpace(ParkingSpace space) {
    add(space.id, space);
  }

  // Get all parking spaces
  List<ParkingSpace> getAllParkingSpaces() {
    return getAll();
  }

  // Get parking space by ID
  ParkingSpace? getParkingSpaceById(int id) {
    return getById(id);
  }

  // Update parking space
  void updateParkingSpace(int id, ParkingSpace space) {
    update(id, space);
  }

  // Delete parking space
  void deleteParkingSpace(int id) {
    delete(id);
  }
}
