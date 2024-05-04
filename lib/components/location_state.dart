import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LocationModel extends ChangeNotifier {
  double _longitude = 0;
  double _latitude = 0;

  double get longitude => _longitude;
  double get latitude => _latitude;

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    print('Getting current location access');
    try {
      final hasPermission = await _handleLocationPermission(context);
      if (!hasPermission) {
        print('sad');
        return;
      }
      print('Fetching Location');
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10));
        

      // double distanceInMeters = await Geolocator.distanceBetween(
      //   52.2165157, 6.9437819, 52.3546274, 4.8285838,
      // );
      print('fetched Location');
      _longitude = position.longitude;
      _latitude = position.latitude;
      print('Longitude: $_longitude, Latitude: $_latitude');
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }
}
