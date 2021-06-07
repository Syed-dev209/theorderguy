import 'package:geolocator/geolocator.dart';

class setCurrentLocation{
  static Position _currentlocation;

  static Position get currentlocation => _currentlocation;

  static set currentlocation(Position value) {
    _currentlocation = value;
  }
}