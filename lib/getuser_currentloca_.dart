// ignore_for_file: prefer_final_fields, unused_field, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocation extends StatefulWidget {
  const GetUserCurrentLocation({super.key});

  @override
  State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
}

class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
  static const CameraPosition kGmap = CameraPosition(
    target: LatLng(31.838360, 70.897386),
    zoom: 14.4746,
  );

  List<Marker> marker = [];

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    //loadData();
  }
//get user current location Load Data
  loadData() {
    GetCurentLocation().then((value) async {
      print("lat :" +
          value.latitude.toString() +
          " long : " +
          value.longitude.toString());
      marker.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: "My Current Location")));

      CameraPosition cameraPosition = CameraPosition(
        zoom: 18,
        target: LatLng(value.latitude, value.longitude),
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

//get user current location
  Future<Position> GetCurentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error : " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: kGmap,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          layoutDirection: TextDirection.rtl,
          compassEnabled: true,
          markers: Set<Marker>.of(marker),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_searching_rounded),
          onPressed: () async {
            loadData();
          }),
    );
  }
}
