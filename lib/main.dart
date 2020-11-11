import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:strack/pages/StrackHome.dart';
import 'package:strack/test/testfinal.dart';
import 'test/test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SafeArea(
            child: Scaffold(
                appBar: AppBar(title: Text('Strack'),
                centerTitle: true,),
                body:testFinal()//StrackHome()
                //App()
               //StrackHome()
                )));
  }
}
