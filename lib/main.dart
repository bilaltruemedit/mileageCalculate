import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';


class DistanceCalculatorScreen extends StatefulWidget {
  @override
  _DistanceCalculatorScreenState createState() => _DistanceCalculatorScreenState();
}

class _DistanceCalculatorScreenState extends State<DistanceCalculatorScreen> {
  final TextEditingController _lat1Controller = TextEditingController();
  final TextEditingController _lon1Controller = TextEditingController();
  final TextEditingController _lat2Controller = TextEditingController();
  final TextEditingController _lon2Controller = TextEditingController();

  double _distance = 0.0;

  Future<void> _calculateDistance() async {
    double distanceInMeters = await Geolocator.distanceBetween(
        double.parse(_lat1Controller.text), double.parse(_lon1Controller.text), double.parse(_lat2Controller.text), double.parse(_lon2Controller.text));
    debugPrint("distance is meters: $distanceInMeters");

  double distanceInMiles = distanceInMeters / 1609.34;
  debugPrint("distance is miles: $distanceInMiles");


    setState(() {
      _distance = distanceInMiles;
    });
  }

  double _calculateDistanceInMiles(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radius of the Earth in kilometers
    const conversionFactor = 0.621371; // Kilometers to miles conversion factor
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distanceInKilometers = R * c;
    return distanceInKilometers * conversionFactor; // Distance in miles
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _lat1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phleb Latitude',
              ),
            ),
            TextField(
              controller: _lon1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phleb Longitude',
              ),
            ),
            TextField(
              controller: _lat2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Facility Latitude',
              ),
            ),
            TextField(
              controller: _lon2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Facility Longitude ',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateDistance,
              child: Text('Calculate Distance'),
            ),
            SizedBox(height: 20),
            Text(
              'Distance: ${_distance.toStringAsFixed(2)} miles',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DistanceCalculatorScreen(),
  ));
}


