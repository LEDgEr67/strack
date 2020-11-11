import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StrackHome extends StatefulWidget {
  @override
  _StrackHomeState createState() => _StrackHomeState();
}

class _StrackHomeState extends State<StrackHome> {
  GoogleMapController mapController;
  static const _init = LatLng(9.695273, 78.455972);
  static LatLng _last = _init;
  Set<Marker> marker = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: initPos(),
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          compassEnabled: true,
          markers: marker,
          onCameraMove: cameraMoved,
        ),
        Positioned(
            bottom: 20,
            right: 100,
            child: Row(
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(CupertinoIcons.add),
                  onPressed: ()=> addMarker(),
                ),
                  SizedBox(width: 10,),
                FloatingActionButton(
                  child: Icon(CupertinoIcons.delete),
                  onPressed: () => clearMarker(),
                ),
                SizedBox(width: 10,),
                FloatingActionButton(
                  child: Icon(CupertinoIcons.location),
                  onPressed: ()
                  {
                    setState(() {
                      _last=_init;
                      mapController.animateCamera(CameraUpdate.newCameraPosition(initPos()));

                    });
                  },
                ),
              ],
            ))
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;

    });
  }

  addMarker() {
    setState(() {
      marker.add(Marker(
        markerId: MarkerId(_last.toString()),
        position: _last,
        icon: BitmapDescriptor.defaultMarker,
      )
      );
      print(marker);
    });

  }

  void cameraMoved(CameraPosition position) {
    setState(() {
      _last = position.target;
    });
  }

  clearMarker() {
    setState(() {
      marker={};
    });
  }
  CameraPosition initPos(){
    return CameraPosition(target: _last,
      zoom: 15,);
  }
}
