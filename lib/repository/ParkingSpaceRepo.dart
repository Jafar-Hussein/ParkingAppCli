import '../Database.dart';
import '../model/ParkingSpace.dart';
class ParkingSpaceRepo{
// Adding a new parking space
  Future<void> addParkingSpace(ParkingSpace parkingSpace) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
        'INSERT INTO parking_space (address, price_per_hour) VALUES (:address, :price_per_hour)',
        {
          'address': parkingSpace.address,
          'price_per_hour': parkingSpace.pricePerHour
        }
      );
      print('Parking space added successfully.');
    } catch (e) {
      print('Error: could not add parking space $e');
    } finally {
      await conn.close();
    }
  }
    Future<List<ParkingSpace>> getAllParkingSpaces() async {
    var conn = await Database.getConnection();
    List<ParkingSpace> parkingSpaces = [];
    try {
      var results = await conn.execute('SELECT * FROM parking_space');
      for (final row in results.rows) {
        var parkingSpace = ParkingSpace(
          id: row.colAt(0) as int,
          address: row.colAt(1) as String,
          pricePerHour: row.colAt(2) as double
        );
        parkingSpaces.add(parkingSpace);
      }
    } catch (e) {
      print('Error: failed to fetch parking spaces. $e');
      return [];
    } finally {
      conn.close();
    }
    return parkingSpaces;
  }
  Future<ParkingSpace?> getParkingSpaceById(int id) async {
    var conn = await Database.getConnection();
    try {
      var results = await conn.execute(
        'SELECT * FROM parking_space WHERE id = :id', {'id': id}
      );
      if (results.rows.isNotEmpty) {
        var row = results.rows.first;
        return ParkingSpace(
          id: row.colAt(0) as int,
          address: row.colAt(1) as String,
          pricePerHour: row.colAt(2) as double
        );
      }
      return null; // Return null if no parking space was found
    } catch (e) {
      print('Error: failed to fetch parking space. $e');
      return Future.error('Failed to fetch parking space');
    } finally {
      await conn.close();
    }
  }
  Future<void> updateParkingSpace(ParkingSpace parkingSpace) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
        'UPDATE parking_space SET address = :address, price_per_hour = :price_per_hour WHERE id = :id',
        {
          'id': parkingSpace.id,
          'address': parkingSpace.address,
          'price_per_hour': parkingSpace.pricePerHour
        }
      );
      print('Parking space updated successfully.');
    } catch (e) {
      print('Error: could not update parking space $e');
    } finally {
      await conn.close();
    }
  }
  Future<void> deleteParkingSpace(int id) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
        'DELETE FROM parking_space WHERE id = :id',
        {'id': id}
      );
      print('Parking space deleted successfully.');
    } catch (e) {
      print('Error: could not delete parking space $e');
    } finally {
      await conn.close();
    }
  }
}

