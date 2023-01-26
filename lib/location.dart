import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoTracking extends StatefulWidget {
  const GeoTracking({super.key});

  @override
  State<GeoTracking> createState() => _GeoTrackingState();
}

class _GeoTrackingState extends State<GeoTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(22.68357, 72.8790084);
  static const LatLng destination = LatLng(22.68357, 72.8790084);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tracking",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: sourceLocation, zoom: 1.5),
        ));
  }
}