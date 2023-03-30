import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iamsafe/database.dart';
import 'package:location/location.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:iamsafe/microphone.dart';

class LocationCheck {
  final soundDetector = SoundDetector();
  LocationData? currentPosition;
  final Location locationService = Location();
  late final MapController mapController = MapController();
  StreamSubscription<GeofenceEvent>? geofenceEventStream;

  void sendSms(String phoneNum) async {
    await [Permission.sms].request();

    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNum, message: "Hello! Sample message");

    if (result == SmsStatus.sent) {
      // ignore: avoid_print
      print("Sent");
    } else {
      // ignore: avoid_print
      print("Failed");
    }
  }

  Future checkGeoFence() async {
    soundDetector.accessMicrophone();
    soundDetector.startListening();
    // soundDetector.startRecording();
    Map<dynamic, dynamic> map;
    final user = FirebaseAuth.instance.currentUser;
    map = (await DatabaseService().getUser(user!.uid));

    await Geofence.startGeofenceService(
        pointedLatitude: map['lat1'].toString(),
        pointedLongitude: map['lon1'].toString(),
        radiusMeter: "200",
        eventPeriodInSeconds: 300);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        if (event == GeofenceEvent.exit) {
          Future.delayed(const Duration(minutes: 3), () {
            sendSms(map['guardian1'].toString());
            sendSms(map['guardian2'].toString());
            sendSms(map['guardian3'].toString());
          });
        }

        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          Geofence.stopGeofenceService();
          geofenceEventStream!.cancel();
          soundDetector.stopRecording();
          soundDetector.destroyMcrophone();
        }
      });
    }

    await Geofence.startGeofenceService(
        pointedLatitude: map['lat2'].toString(),
        pointedLongitude: map['lon2'].toString(),
        radiusMeter: "200",
        eventPeriodInSeconds: 300);

    // ignore: prefer_conditional_assignment
    if (geofenceEventStream == null) {
      geofenceEventStream =
          Geofence.getGeofenceStream()?.listen((GeofenceEvent event) {
        while (event != GeofenceEvent.enter) {
          Future.delayed(const Duration(milliseconds: 500), () {
            sendSms(map['guardian1'].toString());
            sendSms(map['guardian2'].toString());
            sendSms(map['guardian3'].toString());
          });
        }
        if (event == GeofenceEvent.enter) {
          print("Inside geofence");
          Geofence.stopGeofenceService();
          geofenceEventStream!.cancel();
          soundDetector.stopRecording();
          soundDetector.destroyMcrophone();
        }
      });
    }
  }
}
