// ignore_for_file: prefer_const_constructors, unused_import, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'dart:io' show Platform;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PickAddressMap extends StatefulWidget {
  const PickAddressMap({super.key});

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

var userLocation;

class _PickAddressMapState extends State<PickAddressMap> {
  var latitude;
  var longtitude;
  String address = "";
  var addressLatitude;
  var addressLongtitude;

  var addressController;
  var postalController;
  var cityController;
  var countyController;
  var countryController;
  var houseNoController;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      latitude = position.latitude;
      longtitude = position.longitude;
    });
    return userLocation;
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 30),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
            // style: raisedButtonStyle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacePicker(
                    apiKey: "AIzaSyCNpV4UY0noGgT86B134PfGziQODVF1MtE",
                    onPlacePicked: (result) async {
                      //Navigator.pop(context);
                      await processresult(result);
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                " Address Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('House No.'),
                                    subtitle: Text(houseNoController),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(ClipboardData(
                                            text: houseNoController));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('Full address'),
                                    subtitle: Text(address),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                            ClipboardData(text: address));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('Latitude'),
                                    subtitle: Text(addressLatitude),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                          ClipboardData(text: addressLatitude),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('Longtitude'),
                                    subtitle: Text(addressLongtitude),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                          ClipboardData(
                                              text: addressLongtitude),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('Zip/PostCode'),
                                    subtitle: Text(postalController),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                          ClipboardData(text: postalController),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('County'),
                                    subtitle: Text(countyController),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                          ClipboardData(text: countyController),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.local_attraction),
                                    title: Text('Town/City'),
                                    subtitle: Text(countyController),
                                    trailing: IconButton(
                                      icon: Icon(Icons.copy_rounded),
                                      onPressed: () async {
                                        Get.snackbar(
                                            "Copy", "successfully copied",
                                            backgroundColor: Colors.green);
                                        await Clipboard.setData(
                                          ClipboardData(text: cityController),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "close",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.amber),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                    initialPosition: userLocation,
                    useCurrentLocation: true,
                    resizeToAvoidBottomInset:
                        true, // remove this line, if map offsets are wrong
                  ),
                ),
              );
            },
            child: Text('Click to Pick Address'),
          ))
        ],
      ),
    );
  }

  processresult(PickResult result) {
    address = result.formattedAddress!.toString();

    addressLatitude = result.geometry!.location.lat.toString();
    addressLongtitude = result.geometry!.location.lng.toString();

    for (var i in result.addressComponents!) {
      if (i.types.first == "street_number") {
        houseNoController = i.longName;
      }

      if (i.types.first == "postal_code") {
        postalController = i.longName;
      }

      if (i.types.first == "administrative_area_level_2") {
        countyController = i.longName;
      }
      if (i.types.first == "postal_town" || i.types.first == "locality") {
        cityController = i.longName;
      }
      if (i.types.first == "country") {
        countryController = i.longName;
      }
    }
  }
}
