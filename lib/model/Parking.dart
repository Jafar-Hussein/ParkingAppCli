import 'Vehicle.dart';
import 'ParkingSpace.dart';

class Parking {
  int _id;
  Vehicle _vehicle;
  ParkingSpace _parkingSpace;
  DateTime _startTime;
  DateTime? _endTime;
  double? _price;

  Parking({
    required int id,
    required Vehicle vehicle,
    required ParkingSpace parkingSpace,
    required DateTime startTime,
    DateTime? endTime,
  })  : _id = id,
        _vehicle = vehicle,
        _parkingSpace = parkingSpace,
        _startTime = startTime,
        _endTime = endTime;

  // Getters
  int get id => _id;
  Vehicle get vehicle => _vehicle;
  ParkingSpace get parkingSpace => _parkingSpace;
  DateTime get startTime => _startTime;
  DateTime? get endTime => _endTime;
  double? get price => _price;

  // Setters
  set id(int value) => _id = value;
  set vehicle(Vehicle value) => _vehicle = value;
  set parkingSpace(ParkingSpace value) => _parkingSpace = value;
  set startTime(DateTime value) => _startTime = value;
  set endTime(DateTime? value) => _endTime = value;
  set price(double? value) => _price = value;

// Metod för att beräkna parkeringskostnaden
  double parkingCost() {
    // Om sluttiden inte är angiven, anta att bilen fortfarande är parkerad och använd nuvarande tid
    DateTime exitTime = _endTime ?? DateTime.now();

    // Beräknar parkeringsdurationen i timmar (konverterar från minuter till timmar)
    double durationInHours = exitTime.difference(_startTime).inMinutes / 60.0;

    // Multiplicerar antalet timmar med priset per timme för att få total kostnad
    double totalCost = durationInHours * _parkingSpace.pricePerHour;

    return totalCost;
  }
}
