import 'dart:collection';

import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final Map<String, int> _quantities = {};

  /// An unmodifiable view of the items in the cart.
  UnmodifiableMapView<String, int> get quantities =>
      UnmodifiableMapView(_quantities);

  void add(String item) {
    print(item);
    if (_quantities.containsKey(item)) {
      _quantities[item] = _quantities[item]! + 1;
      print(_quantities[item]);
    } else {
      _quantities[item] = 1;
    }

    notifyListeners();
  }

  void remove(String item) {
    print(item);
    if (_quantities.containsKey(item)) {
      _quantities[item] = _quantities[item]! - 1;
      print(_quantities[item]);
      if (_quantities[item] == 0) {
        _quantities.remove(item);
      }
    }

    notifyListeners();
  }
}
