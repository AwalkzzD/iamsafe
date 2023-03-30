import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iamsafe/checklocation.dart';
import 'package:iamsafe/database.dart';
import 'package:iamsafe/microphone.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class GeoTracking extends StatefulWidget {
  const GeoTracking({super.key});

  @override
  State<GeoTracking> createState() => _GeoTrackingState();
}

class _GeoTrackingState extends State<GeoTracking> {
  LocationData? _currentPosition;
  final Location _locationService = Location();
  late final MapController _mapController = MapController();
  late Map<dynamic, dynamic> _map;
  final markers = <Marker>[];

  Future _handleLocationPermission() async {
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
          setState(() async {
            _currentPosition = result;
            _mapController.move(
                LatLng(
                    _currentPosition!.latitude!, _currentPosition!.longitude!),
                18);
            return;
          });
        }
      });
    }
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(185, 110, 208, 1),
        fontFamily: 'EduNSWACTFoundation',
      ),
      borderRadius: BorderRadius.circular(15),
      animation: StyledToastAnimation.slideFromTopFade,
      position: StyledToastPosition.top,
      animDuration: const Duration(milliseconds: 50),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.purple.shade50,
      context: context,
    );
  }

  addSafePoints1(String uid, LatLng point) async {
    await DatabaseService().addSafePoint1(
        uid: uid,
        lat1: point.latitude.toString(),
        lon1: point.longitude.toString());
    customToast("Safepoint Added", context);
  }

  addSafePoints2(String uid, LatLng point) async {
    await DatabaseService().addSafePoint2(
        uid: uid,
        lat2: point.latitude.toString(),
        lon2: point.longitude.toString());
    customToast("Safepoint Added", context);
  }

  Future getData() async {
    final user = FirebaseAuth.instance.currentUser;
    _map = (await DatabaseService().getUser(user!.uid));

    setState(() {
      markers.add(
        Marker(
          point: LatLng(double.parse(_map['lat1'].toString()),
              double.parse(_map['lon1'].toString())),
          builder: (ctx) => const Icon(
            Icons.location_pin,
            color: Color.fromARGB(255, 0, 174, 255),
            size: 40,
          ),
        ),
      );
      markers.add(
        Marker(
          point: LatLng(double.parse(_map['lat2'].toString()),
              double.parse(_map['lon2'].toString())),
          builder: (ctx) => const Icon(
            Icons.location_pin,
            color: Color.fromARGB(255, 0, 174, 255),
            size: 40,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    LatLng currentLatLng;
    if (_currentPosition != null) {
      currentLatLng =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    } else {
      currentLatLng = LatLng(20.5937, 78.9629);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.5,
        elevation: 0.5,
        title: const Text(
          "Select SafePoints",
          style: TextStyle(
            fontFamily: 'EduNSWACTFoundation',
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: ((context, snapshot) {
          User? user = snapshot.data;
          return snapshot.hasData
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Flexible(
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: LatLng(currentLatLng.latitude,
                                currentLatLng.longitude),
                            zoom: 5,
                            onLongPress: (tapPosition, point) {
                              showModalBottomSheet<void>(
                                  backgroundColor:
                                      const Color.fromARGB(255, 42, 130, 207),
                                  context: context,
                                  builder: ((context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(
                                              Icons.arrow_right_rounded,
                                              color: Colors.white),
                                          minLeadingWidth: 0,
                                          trailing: const Icon(Icons.check,
                                              color: Colors.white),
                                          title: const Text(
                                            'Add SafePoint 1',
                                            style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            addSafePoints1(user!.uid, point);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.arrow_right_rounded,
                                              color: Colors.white),
                                          minLeadingWidth: 0,
                                          trailing: const Icon(Icons.check,
                                              color: Colors.white),
                                          title: const Text(
                                            'Add Safepoint 2',
                                            style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            addSafePoints2(user!.uid, point);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.arrow_right_rounded,
                                              color: Colors.white),
                                          minLeadingWidth: 0,
                                          trailing: const Icon(Icons.delete,
                                              color: Colors.white),
                                          title: const Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontFamily: 'RobotoSlab',
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              markers.removeLast();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }));
                              markers.add(
                                Marker(
                                    point: point,
                                    builder: (ctx) => const Icon(
                                          Icons.location_pin,
                                          color:
                                              Color.fromARGB(255, 0, 174, 255),
                                          size: 40,
                                        )),
                              );
                            },
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
                            MarkerLayer(markers: markers),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(63, 149, 210, 1),
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
        onPressed: () {
          _getCurrentPosition();
        },
      ),
    );
  }
}
