import '../model/Person.dart';
import '../model/Vehicle.dart';
import '../Database.dart';

class VehicleRepo {
  // Add a vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
          'INSERT INTO vehicle (registreringsnummer, type, owner_id) VALUES (:registreringsnummer, :type, :owner_id)',
          {
            'registreringsnummer': vehicle.registreringsnummer,
            'type': vehicle.type,
            'owner_id': vehicle.owner.id
          });
      print('Vehicle added successfully.');
    } catch (e) {
      print('Error: could not add vehicle $e');
    } finally {
      await conn.close();
    }
  }

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() async {
    var conn = await Database.getConnection();
    List<Vehicle> vehicles = [];
    try {
      var results = await conn.execute(
          'SELECT * FROM vehicle INNER JOIN person ON vehicle.owner_id = person.id');
      for (final row in results.rows) {
        var vehicle = Vehicle(
          id: row.colAt(0) as int,
          registreringsnummer: row.colAt(1) as String,
          type: row.colAt(2) as String,
          owner: Person(
              id: row.colAt(3) as int,
              namn: row.colAt(4) as String,
              personnummer: row.colAt(5) as String),
        );
        vehicles.add(vehicle);
      }
    } catch (e) {
      print('Error: failed to fetch vehicles. $e');
      return [];
    } finally {
      conn.close();
    }
    return vehicles;
  }

  // Get a single vehicle by ID
  Future<Vehicle?> getVehicleById(int id) async {
    if (id <= 0) {
      print('Error: ID must be greater than zero.');
      return Future.error('Invalid ID');
    }

    var conn = await Database.getConnection();
    try {
      var results = await conn.execute(
          'SELECT vehicle.id, vehicle.registreringsnummer, vehicle.type, '
          'person.id AS personId, person.namn, person.personnummer '
          'FROM vehicle '
          'INNER JOIN person ON vehicle.owner_id = person.id '
          'WHERE vehicle.id = :id',
          {'id': id});

      if (results.rows.isNotEmpty) {
        var row = results.rows.first;
        Person owner = Person(
            id: row.colAt(3) as int,
            namn: row.colAt(4) as String,
            personnummer: row.colAt(5) as String);

        return Vehicle(
            id: row.colAt(0) as int,
            registreringsnummer: row.colAt(1) as String,
            type: row.colAt(2) as String,
            owner: owner);
      }
      return null;
    } catch (e) {
      print('Error: failed to fetch vehicle. $e');
      return Future.error('Failed to fetch vehicle');
    } finally {
      await conn.close();
    }
  }

  // Update a vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute(
          'UPDATE vehicle SET registreringsnummer = :registreringsnummer, type = :type, owner_id = :owner_id WHERE id = :id',
          {
            'id': vehicle.id,
            'registreringsnummer': vehicle.registreringsnummer,
            'type': vehicle.type,
            'owner_id': vehicle.owner.id
          });
      print('Vehicle updated successfully.');
    } catch (e) {
      print('Error: could not update vehicle $e');
    } finally {
      await conn.close();
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(int id) async {
    var conn = await Database.getConnection();
    try {
      await conn.execute('DELETE FROM vehicle WHERE id = :id', {'id': id});
      print('Vehicle deleted successfully.');
    } catch (e) {
      print('Error: could not delete vehicle $e');
    } finally {
      await conn.close();
    }
  }
}
