import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiModel extends ChangeNotifier {
  List _pharmacies = [];
  List _medicine_stores = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView get pharmacies => UnmodifiableListView(_pharmacies);
  UnmodifiableListView get medicine_stores =>
      UnmodifiableListView(_medicine_stores);
  void getNearbyPharmacies(double lat, double long) async {
    var url = Uri.parse('http://172.31.219.169:8000/cart/list_pharmacies');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Handle successful response
      var data = json.decode(response.body);
      // print("KJHKJH");
      // print(_pharmacies[0]);
      data.sort((a, b) =>
          Geolocator.distanceBetween(lat, long, a["lat"], a["long"]) <
                  Geolocator.distanceBetween(lat, long, b["lat"], b["long"])
              ? -1
              : (Geolocator.distanceBetween(lat, long, a["lat"], a["long"]) >
                      Geolocator.distanceBetween(lat, long, b["lat"], b["long"])
                  ? 1
                  : 0));
      _pharmacies = data;
      print(data);
      print('API request successful');
    } else {
      // Handle error response
      print('API request failed');
    }
  }

  Future<List> findStores(Map<String, Object> ob) async {
    List<Map<String, Object>> medicines = [];
    ob.forEach((key, value) {
      medicines.add({'name': key.toLowerCase(), 'quantity': value});
    });

    var url = Uri.parse('http://172.31.219.169:8000/cart/price');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'items': medicines,
        }));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      _medicine_stores = data["results"];
      return data["results"];
    } else {
      return [];
    }
  }
  // bool placeOrder(List medicines, String pharmacy, String accessToken) {
  //   var url = Uri.parse('http://172.31.219.169:8000/cart/buy');
  // }
}
