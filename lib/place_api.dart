import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlaceApi extends StatefulWidget {
  const GooglePlaceApi({Key? key}) : super(key: key);

  @override
  _GooglePlaceApiState createState() => _GooglePlaceApiState();
}

class _GooglePlaceApiState extends State<GooglePlaceApi> {
  TextEditingController controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = "123456";
  List<dynamic> placeList = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken != null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestions(controller.text.toString());
  }

//get sugesstion from Api
  void getSuggestions(String input) async {
    String kplacesApiKey =
        'AIzaSyCJX4VrhMwdlBlHf4zVLS3evTro907O9ZQ';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        placeList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception(
          "Failed to load: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Place API"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Search place',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: placeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(placeList[index]['description']),
                    onTap: () async {
                      List<Location> location = await locationFromAddress(
                          placeList[index]['description']);
                      print("Lat : " + location.last.latitude.toString());
                      print("Long : " + location.last.longitude.toString());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
