import 'package:flutter/foundation.dart';

class DriverInfo extends ChangeNotifier {
  String? _driverId;

  String? get driverId => _driverId;

  setDriverId(String id) {
    _driverId = id;
    notifyListeners();
  }
}