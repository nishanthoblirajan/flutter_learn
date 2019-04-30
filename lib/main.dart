import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/productscreen.dart';
import 'package:hello_world/layouts.dart';
import 'package:hello_world/addproductscreen.dart';


void main() => runApp(
    MaterialApp(
      home: MyApp(),
      routes: <String, WidgetBuilder>{
        '/myapp':(context)=>MyApp(),
        '/productscreen':(context)=>productscreen(),
        '/addproductscreen':(context)=>addproductscreen()
      },
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('LSSM'),
        ),
        body: buildContainer(),
        drawer: buildDrawer(context),
      );
  }



  Widget buildContainer() {
    return new Container(
      child: Text('Dashboard'),
    );
  }
}
