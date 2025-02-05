import '../Database.dart';
import '../model/Parking.dart';
import '../model/Vehicle.dart';
import '../model/ParkingSpace.dart';
import '../model/Person.dart';

class ParkingRepo {
  // Adding a new parking record
  Future<void> addParking(Parking parking) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
          'INSERT INTO parking (vehicle_id, parking_space_id, start_time, end_time) VALUES (:vehicle_id, :parking_space_id, :start_time, :end_time)',
          {
            'vehicle_id': parking.vehicle.id,
            'parking_space_id': parking.parkingSpace.id,
            'start_time': parking.startTime.toIso8601String(),
            'end_time': parking.endTime?.toIso8601String(),
          });
      print('Parking added successfully.');
    } catch (e) {
      print('Error: could not add parking $e');
    } finally {
      await conn.close();
    }
  }

  // Retrieve all parking records with full vehicle and owner details
  Future<List<Parking>> getAllParkings() async {
    var conn = await Database.getConnection();
    List<Parking> parkings = [];
    try {
      var results =
          await conn.execute('SELECT p.*, v.*, ps.*, per.* FROM parking p '
              'JOIN vehicle v ON p.vehicle_id = v.id '
              'JOIN parking_space ps ON p.parking_space_id = ps.id '
              'JOIN person per ON v.owner_id = per.id');
      for (final row in results.rows) {
        var vehicle = Vehicle(
            id: row.colAt(0) as int,
            registreringsnummer: row.colAt(1) as String,
            type: row.colAt(2) as String,
            owner: Person(
                id: row.colAt(3) as int,
                namn: row.colAt(4) as String,
                personnummer: row.colAt(5) as String));
        var parkingSpace = ParkingSpace(
          id: row.colAt(6) as int,
          address: row.colAt(7) as String,
          pricePerHour: row.colAt(8) as double,
        );
        var parking = Parking(
          id: row.colAt(9) as int,
          vehicle: vehicle,
          parkingSpace: parkingSpace,
          startTime: DateTime.parse(row.colAt(10) as String),
          endTime: row.colAt(11) != null
              ? DateTime.parse(row.colAt(11) as String)
              : null,
        );
        parkings.add(parking);
      }
    } catch (e) {
      print('Error: failed to fetch parkings. $e');
      return [];
    } finally {
      await conn.close();
    }
    return parkings;
  }

  Future<Parking?> getParkingById(int id) async {
    var conn = await Database.getConnection();
    try {
      var results = await conn.execute(
          'SELECT p.id, v.id, v.registreringsnummer, v.type, per.id, per.namn, per.personnummer, ps.id, ps.address, ps.pricePerHour, p.start_time, p.end_time '
          'FROM parking p '
          'JOIN vehicle v ON p.vehicle_id = v.id '
          'JOIN person per ON v.owner_id = per.id '
          'JOIN parking_space ps ON p.parking_space_id = ps.id '
          'WHERE p.id = :id',
          {'id': id});
      if (results.rows.isNotEmpty) {
        var row = results.rows.first;
        var parking = Parking(
            id: row.colAt(0) as int,
            vehicle: Vehicle(
                id: row.colAt(1) as int,
                registreringsnummer: row.colAt(2) as String,
                type: row.colAt(3) as String,
                owner: Person(
                    id: row.colAt(4) as int,
                    namn: row.colAt(5) as String,
                    personnummer: row.colAt(6) as String)),
            parkingSpace: ParkingSpace(
                id: row.colAt(7) as int,
                address: row.colAt(8) as String,
                pricePerHour: row.colAt(9) as double),
            startTime: DateTime.parse(row.colAt(10) as String),
            endTime: row.colAt(11) != null
                ? DateTime.parse(row.colAt(11) as String)
                : null);
        return parking;
      }
      return null; // Return null if no parking was found
    } catch (e) {
      print('Error: failed to fetch parking. $e');
      return Future.error('Failed to fetch parking');
    } finally {
      await conn.close();
    }
  }

  Future<void> updateParking(Parking parking) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
          'UPDATE parking SET vehicle_id = :vehicle_id, parking_space_id = :parking_space_id, start_time = :start_time, end_time = :end_time '
          'WHERE id = :id',
          {
            'id': parking.id,
            'vehicle_id': parking.vehicle.id,
            'parking_space_id': parking.parkingSpace.id,
            'start_time': parking.startTime.toIso8601String(),
            'end_time': parking.endTime?.toIso8601String(),
          });
      print('Parking updated successfully.');
    } catch (e) {
      print('Error: could not update parking $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> deleteParking(int id) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute('DELETE FROM parking WHERE id = :id', {'id': id});
      print('Parking deleted successfully.');
    } catch (e) {
      print('Error: could not delete parking $e');
    } finally {
      await conn.close();
    }
  }
}
