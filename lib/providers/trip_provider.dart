import 'package:flutter/foundation.dart';

class TripProvider extends ChangeNotifier {
  final List<dynamic> _trips = [];

  List<dynamic> get trips => List.unmodifiable(_trips);

  void addTrip(dynamic trip) {
    _trips.add(trip);
    notifyListeners();
  }

  dynamic removeTrip(int index) {
    final removedTrip = _trips.removeAt(index);
    notifyListeners();
    return removedTrip;
  }

  void insertTrip(int index, dynamic trip) {
    _trips.insert(index, trip);
    notifyListeners();
  }
}
