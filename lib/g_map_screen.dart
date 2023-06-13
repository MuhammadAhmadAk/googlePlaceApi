// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapScreen extends StatefulWidget {
  const GMapScreen({super.key});

  @override
  State<GMapScreen> createState() => _GMapScreenState();
}

class _GMapScreenState extends State<GMapScreen> {
  static const CameraPosition kGmap = CameraPosition(
    target: LatLng(31.838360, 70.897386),
    zoom: 14.4746,
  );

  List<Marker> list = [
    const Marker(
        markerId: MarkerId("1"),
        position: LatLng(31.838360, 70.897386),
        infoWindow: InfoWindow(title: "My Office")),
    const Marker(
        markerId: MarkerId("2"),
        position: LatLng(
          39.9890,
          116.3207,
        ),
        infoWindow: InfoWindow(title: "China"))
  ];

  List<Marker> marker = [];

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    marker.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: kGmap,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          layoutDirection: TextDirection.rtl,
          compassEnabled: true,
          markers: Set<Marker>.of(marker),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_disabled_outlined),
          onPressed: () async {
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(const CameraPosition(
                    target: LatLng(
                      39.9890,
                      116.3207,
                    ),
                    zoom: 14.72)));
            setState(() {});
          }),
    );
  }
}
