// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, unnecessary_new, avoid_print
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LatLog_into_Address extends StatefulWidget {
  const LatLog_into_Address({super.key});
  @override
  State<LatLog_into_Address> createState() => _LatLog_into_AddressState();
}

class _LatLog_into_AddressState extends State<LatLog_into_Address> {
  // Geocoder geo = Geocoder();
  // //Address
  // Future<String> getAddress(double pLon, double pLat) {
  //   return geo.getAddressFromLonLat(pLon, pLat);
  // }

  String stAdress = "", stdAdd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(stAdress),
          Text(stdAdd),
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    List<Location> locations = await locationFromAddress(
                        "Gronausestraat 710, Enschede");
                    print(locations.last.longitude.toString() +
                        " " +
                        locations.last.longitude.toString());
                    List<Placemark> placemarks =
                        await placemarkFromCoordinates(52.2165157, 6.9437819);

                    setState(() {
                      stAdress = "long  : " +
                          locations.last.longitude.toString() +
                          " lat : " +
                          locations.last.latitude.toString();
                      stdAdd = placemarks.reversed.last.country.toString() +
                          " " +
                          placemarks.reversed.last.locality.toString() +
                          " " +
                          placemarks.reversed.last.subLocality.toString();
                    });
                  },
                  child: const Text("Convert")))
        ],
      )),
    );
  }
}
