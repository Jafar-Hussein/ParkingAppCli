import '../model/Person.dart';
import '../Database.dart';

class PersonRepo {
  /// Lägger till en person i databasen.
  Future<void> addPerson(Person person) async {
    var conn = await Database.getConnection();
    try {
      // Kontrollera att namn och personnummer inte är tomma
      if ((person.getNamn ?? '').isEmpty ||
          (person.getPersonnummer ?? '').isEmpty) {
        print('Error: Name or personnummer is empty.');
        return;
      }

      // Kör SQL-frågan för att lägga till en person
      await conn.execute(
        'INSERT INTO person (namn, personnummer) VALUES (:namn, :personnummer)',
        {
          'namn': person.getNamn,
          'personnummer': person.getPersonnummer,
        } 
      );
      print('Person added successfully.');
    } catch (e) {
      // Loggar fel om något går fel
      print('Error: failed to add person. $e');
    } finally {
      // Stänger databaskopplingen
      await conn.close();
    }
  }

  /// Hämtar alla personer från databasen och returnerar dem som en lista av Person-objekt.
  Future<List<Person>> getAll() async {
    var conn = await Database.getConnection();
    try {
      // Kör SQL-frågan för att hämta alla personer från databasen
      var results = await conn.execute('SELECT * FROM person');

      // Omvandlar varje rad i resultatet till ett Person-objekt
      return results.rows.map((row) {
        return Person(
          id: int.tryParse(row.colAt(0)?.toString() ?? '0') ??
              0, // Första kolumnen: id, säkert typkastad till int
          namn: row.colAt(1)?.toString() ??
              '', // Andra kolumnen: namn, säkert omvandlad till String
          personnummer: row.colAt(2)?.toString() ??
              '', // Tredje kolumnen: personnummer, säkert omvandlad till String
        );
      }).toList();
    } catch (e) {
      // Loggar fel om något går fel
      print('Error: failed to fetch persons. $e');
      return [];
    } finally {
      // Stänger databaskopplingen
      await conn.close();
    }
  }

  /// Hämtar en person från databasen baserat på ID.
  Future<Person?> getById(int id) async {
    // Kontrollera att ID är giltigt
    if (id <= 0) {
      print('Error: ID must be greater than zero.');
      return Future.error('Invalid ID');
    }

    var conn = await Database.getConnection();
    try {
      // Kör SQL-frågan för att hämta personen med det angivna ID:t
      var results = await conn.execute(
        'SELECT * FROM person WHERE id = :id',
        {'id': id}, // Använder en Map istället för en lista
      );

      // Kontrollera om en person hittades
      if (results.rows.isNotEmpty) {
        var row = results.rows.first;
        return Person(
          id: int.tryParse(row.colAt(0)?.toString() ?? '0') ??
              0, // Första kolumnen: id
          namn: row.colAt(1)?.toString() ?? '', // Andra kolumnen: namn
          personnummer:
              row.colAt(2)?.toString() ?? '', // Tredje kolumnen: personnummer
        );
      }
      return null; // Returnerar null om personen inte hittades
    } catch (e) {
      // Loggar fel om något går fel
      print('Error: failed to fetch person by ID. $e');
      return null;
    } finally {
      // Stänger databaskopplingen
      await conn.close();
    }
  }

  /// Uppdaterar en person i databasen.
  Future<Person?> updatePerson(Person person) async {
    var conn = await Database.getConnection();
    try {
      // Kör SQL-frågan för att uppdatera personens uppgifter
      await conn.execute(
        'UPDATE person SET namn = :namn, personnummer = :personnummer WHERE id = :id',
        {
          'namn': person.getNamn,
          'personnummer': person.getPersonnummer,
          'id': person.getId,
        }, // Använder en Map istället för en lista
      );
      print('Person has been updated in the database.');

      // Hämta och returnera den uppdaterade personen
      var results = await conn.execute(
        'SELECT * FROM person WHERE id = :id',
        {'id': person.getId}, // Använder en Map för parameterbindning
      );

      if (results.rows.isNotEmpty) {
        var row = results.rows.first;
        return Person(
          id: int.tryParse(row.colAt(0)?.toString() ?? '0') ??
              0, // Första kolumnen: id
          namn: row.colAt(1)?.toString() ?? '', // Andra kolumnen: namn
          personnummer:
              row.colAt(2)?.toString() ?? '', // Tredje kolumnen: personnummer
        );
      }
      return null; // Returnerar null om personen inte hittades
    } catch (e) {
      // Loggar fel om något går fel
      print('Error: failed to update person. $e');
      return null;
    } finally {
      // Stänger databaskopplingen
      await conn.close();
    }
  }

  /// Tar bort en person från databasen baserat på ID.
  Future<void> deleteById(int id) async {
    var conn = await Database.getConnection();
    try {
      // Kontrollera om personen finns innan borttagning
      var results = await conn.execute(
        'SELECT * FROM person WHERE id = :id',
        {'id': id}, // Använd en Map för parameterbindning
      );

      if (results.rows.isNotEmpty) {
        // Kör SQL-frågan för att ta bort personen
        await conn.execute(
          'DELETE FROM person WHERE id = :id',
          {'id': id}, // Använd en Map för parameterbindning
        );
        print('Person with ID $id has been deleted from the database.');
      } else {
        // Loggar om personen inte hittades
        print('No person found with ID $id.');
      }
    } catch (e) {
      // Loggar fel om något går fel
      print('Could not delete the person. Error: $e');
    } finally {
      // Stänger databaskopplingen
      await conn.close();
    }
  }
}
