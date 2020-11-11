import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

// ignore: camel_case_types
class testFinal extends StatefulWidget {
  @override
  _testFinalState createState() => _testFinalState();
}

// ignore: camel_case_types
class _testFinalState extends State<testFinal> {
  GoogleMapController mapController;
  List<Marker> marker = [];
  bool error;
  Position userlocation;
  GeoPoint fireloc;
  DocumentReference users;
  bool mapcreated = false;
  bool mapupdated = false;
  addMark() {
    print(userlocation);
    setState(() {
      marker = [];
      mapupdated = true;
      marker.add(Marker(
          markerId: MarkerId(userlocation.toString()),
          position: LatLng(userlocation.latitude, userlocation.longitude)));
      mapcreated == true
          ? mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(userlocation.latitude, userlocation.longitude),
                  zoom: 15)))
          : mapcreated = false;
    });
  }

  Future<void> fire(Position pos) {
    return users
        .update({'loc': GeoPoint(pos.latitude, pos.longitude)})
        .then((value) => addMark())
        .catchError((onError) => print('Error $onError'));
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      LocationPermission permission = await requestPermission();
      await checkPermission().then((value) => print('>>>>$value<<<<<'));
      await Firebase.initializeApp();
      users = FirebaseFirestore.instance.collection('location').doc('loc');
      await getPositionStream(
              desiredAccuracy: LocationAccuracy.high, timeInterval: 10000)
          .listen((Position position) {
        userlocation = position;
        fire(position);
      });
    } catch (e) {
      print(">>>>>>>{$e}<<<<<<<<<<<<");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return (users.snapshots().toList() !=null)
        ? StreamBuilder<DocumentSnapshot>(

            stream: users.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.data == null) {
                print("Returning Null");
                return Center(child: Text('Returned null'));
              }
              var m = snapshot.data.data()['loc'];
              print(m.latitude);
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(m.latitude, m.longitude), zoom: 5),
                    markers: Set.from(marker),
                    onMapCreated: mapCreated,
                    zoomControlsEnabled: false,
                  )
                ],
              );
            })
        : Center(
            child: Text('Loading'),
          );
  }

  void mapCreated(GoogleMapController controller) {
    mapController = controller;
    mapcreated = true;
  }
}
