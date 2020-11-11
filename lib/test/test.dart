import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  dynamic pos;
  List<Marker> mark = [];
  GoogleMapController mapController;
  DocumentReference users;
  Future<void> addMark(LatLng l) {
    // Call the user's CollectionReference to add a new user
    GeoPoint m;
    users.get().then((DocumentSnapshot value) { m=((value.data()['loc']));print(m.longitude);});

    return users
        .update({
          'loc': GeoPoint(l.latitude, l.longitude), // John Doe
        })
        .then((value) => print("Location Updated"))
        .catchError((error) => print("Failed To Update Location: $error"));


  }

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      users = FirebaseFirestore.instance.collection('location').doc('loc');
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Center(
        child: Text('Something Went Wrong'),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(
        child: Text('Something Went Wrong'),
      );
    }

    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(55, 22),
            zoom: 12,
            tilt: 8,
          ),
          markers: Set.from(mark),
          onMapCreated: mapCreated,
          zoomControlsEnabled: false,
          compassEnabled: false,
        ),
        Positioned(
            bottom: 20,
            right: 170,
            child: FloatingActionButton(
              child: Icon(
                CupertinoIcons.location,
              ),
              onPressed: loc,
            ))
      ],
    );
  }

  loc() async {
    pos = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng l = LatLng(pos.latitude, pos.longitude);

    setState(() {
      mark = [];
      mark.add(Marker(
          markerId: MarkerId(l.toString()),
          position: l,
          icon: BitmapDescriptor.defaultMarker));
      addMark(l);
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: l, zoom: 12)));
    });
  }

  void mapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
