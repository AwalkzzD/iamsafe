import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iamsafe/database.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
  StreamSubscription<GeofenceEvent>? geofenceEventStream;

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
    showToast(message,
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.amberAccent,
          fontFamily: 'RobotoSlab',
        ),
        borderRadius: BorderRadius.circular(15),
        animation: StyledToastAnimation.slideFromTopFade,
        position: StyledToastPosition.top,
        animDuration: const Duration(milliseconds: 50),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[600],
        context: context);
  }

  addSafePoints1(String uid, LatLng point) async {
    await DatabaseService().addSafePoint1(
        uid: uid,
        lat1: point.latitude.toString(),
        lon1: point.longitude.toString());

    // LocationData? location = await _locationService.getLocation();
    await Geofence.startGeofenceService(
        pointedLatitude: point.latitude.toString(),
        pointedLongitude: point.longitude.toString(),
        radiusMeter: "100",
        eventPeriodInSeconds: 10);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          customToast("Safepoint close to user", context);
          Geofence.stopGeofenceService();
        }
      });
    }
  }

  void _sendSMS(String message, List<String> recipents) async {
    String result =
        await sendSMS(message: message, recipients: recipents, sendDirect: true)
            .catchError((onError) {
      print(onError);
    });
    print(result);
  }

  addSafePoints2(String uid, LatLng point) async {
    await DatabaseService().addSafePoint2(
        uid: uid,
        lat2: point.latitude.toString(),
        lon2: point.longitude.toString());

    await Geofence.startGeofenceService(
        pointedLatitude: point.latitude.toString(),
        pointedLongitude: point.longitude.toString(),
        radiusMeter: "100",
        eventPeriodInSeconds: 10);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          customToast("Safepoint close to user", context);
          Geofence.stopGeofenceService();
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
      currentLatLng = LatLng(20.5937, 78.9629);
    }

    final markers = <Marker>[];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Select SafePoints",
          style: TextStyle(fontFamily: 'RobotoSlab'),
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
                                  backgroundColor: Colors.amber,
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
                                              markers.remove(
                                                Marker(
                                                    point: point,
                                                    builder: (ctx) =>
                                                        const Icon(
                                                          Icons.location_pin,
                                                          color: Colors.red,
                                                          size: 40,
                                                        )),
                                              );
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
                                          color: Colors.red,
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
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
        onPressed: () {
          String message = "This is a test message!";
          List<String> recipents = ["918734925876"];
          _sendSMS(message, recipents);
          _getCurrentPosition();
          setState(() {
            const Icon(Icons.stop_circle_outlined);
          });
        },
      ),
    );
  }
}
