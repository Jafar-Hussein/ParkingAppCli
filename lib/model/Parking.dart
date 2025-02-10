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
    DateTime exitTime = _endTime ?? DateTime.now();
    double durationInHours = exitTime.difference(_startTime).inMinutes / 60.0;
    double costPerHour = _parkingSpace.pricePerHour;

    // Lägg till pristillägg under högtrafik (t.ex. vardagar mellan 07:00-09:00)
    if (_startTime.hour >= 7 &&
        _startTime.hour <= 9 &&
        _startTime.weekday <= 5) {
      costPerHour *= 1.5; // 50% dyrare under rusningstid
    }

    return durationInHours * costPerHour;
  }
}
