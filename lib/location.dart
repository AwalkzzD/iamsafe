import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GeoTracking extends StatefulWidget {
  const GeoTracking({super.key});

  @override
  State<GeoTracking> createState() => _GeoTrackingState();
}

class _GeoTrackingState extends State<GeoTracking> {
  late String lat;
  late String lon;
  LocationData? _currentPosition;
  final Location _locationService = Location();
  late final MapController _mapController = MapController();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Location services are disabled. Please enable the services")));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permissions are denied")));
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

  Future<void> _getCurrentPosition() async {
    LocationData? location;
    final hasPermission = await _handleLocationPermission();

    if (hasPermission) {
      location = await _locationService.getLocation();
      _currentPosition = location;

      _locationService.onLocationChanged.listen((LocationData result) async {
        if (mounted) {
          setState(() {
            _currentPosition = result;
            _mapController.move(
                LatLng(
                    _currentPosition!.latitude!, _currentPosition!.longitude!),
                18);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    if (_currentPosition != null) {
      currentLatLng =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    } else {
      currentLatLng = LatLng(0, 0);
    }

    final markers = <Marker>[
      Marker(
          point: currentLatLng,
          builder: (ctx) => const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 50,
              )),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                      LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  zoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/awalkzzd/cle31u7fd000801mysawkih6q/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXdhbGt6emQiLCJhIjoiY2xlMzFwcnphMDRobjNwb2ltdWZuNjNhOSJ9.SacNtBuOCBUOjpbH8f8GWg',
                    // ignore: prefer_const_literals_to_create_immutables
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiYXdhbGt6emQiLCJhIjoiY2xlMzFwcnphMDRobjNwb2ltdWZuNjNhOSJ9.SacNtBuOCBUOjpbH8f8GWg',
                      'id': 'mapbox.mapbox-streets-v8'
                    },
                  ),
                  MarkerLayer(markers: markers)
                ],
              ),
            ),
            ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Icon(Icons.my_location))
          ],
        ),
      ),
    );
  }
}
