import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LocationModel extends ChangeNotifier {
  final _pharmacies = [];

  UnmodifiableListView get pharmacies => UnmodifiableListView(_pharmacies);

  void getNearbyPharmacies(String pharmacy, lat, long) {
    _pharmacies.add(pharmacy);
    notifyListeners();
  }
}
