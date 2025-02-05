import 'Person.dart';

class Vehicle {
  int id;
  String registreringsnummer;
  String type; // Bil, motorcykel, etc.
  Person owner;

  Vehicle({
    required this.id,
    required this.registreringsnummer,
    required this.type,
    required this.owner,
  });

  //getters

  int get getId => id;
  String get getRegistreringsnummer => registreringsnummer;
  String get getType => type;
  Person get getOwner => owner;

  //setters
  set setId(int id) {
    if (id <= 0) {
      throw Exception("ID must be greater than zero.");
    }
    this.id = id;
  }

  set setRegistreringsnummer(String regNummer) {
    if (regNummer.isEmpty) {
      throw Exception("Registreringsnummer cannot be empty.");
    }
    this.registreringsnummer = regNummer;
  }

  set setType(String type) => this.type = type;
  set setOwner(Person owner) => this.owner = owner;
}
