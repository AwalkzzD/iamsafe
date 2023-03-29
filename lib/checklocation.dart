import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iamsafe/database.dart';
import 'package:location/location.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCheck {
  LocationData? currentPosition;
  final Location locationService = Location();
  late final MapController mapController = MapController();
  StreamSubscription<GeofenceEvent>? geofenceEventStream;
  late Map<dynamic, dynamic> map;

  void sendSms() async {
    await [Permission.sms].request();

    var result = await BackgroundSms.sendMessage(
        phoneNumber: "8530314846", message: "Hello! Sample message");

    if (result == SmsStatus.sent) {
      // ignore: avoid_print
      print("Sent");
    } else {
      // ignore: avoid_print
      print("Failed");
    }
  }

  Future getData() async {
    final user = FirebaseAuth.instance.currentUser;
    map = (await DatabaseService().getUser(user!.uid));
  }

  Future checkGeoFence() async {
    await Geofence.startGeofenceService(
        pointedLatitude: map['lat1'].toString(),
        pointedLongitude: map['lon1'].toString(),
        radiusMeter: "200",
        eventPeriodInSeconds: 200);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        // if (event == GeofenceEvent.exit) {
        //   Future.delayed(const Duration(minutes: 3), () {
        //     _sendSms();
        //   });
        // }

        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          Geofence.stopGeofenceService();
          geofenceEventStream!.cancel();
        }
      });
    }

    await Geofence.startGeofenceService(
        pointedLatitude: map['lat2'].toString(),
        pointedLongitude: map['lon2'].toString(),
        radiusMeter: "200",
        eventPeriodInSeconds: 200);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        // while (event != GeofenceEvent.enter) {
        //   Future.delayed(const Duration(milliseconds: 500), () {
        //     _sendSms();
        //   });
        // }
        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          Geofence.stopGeofenceService();
          geofenceEventStream!.cancel();
        }
      });
    }
  }
}
