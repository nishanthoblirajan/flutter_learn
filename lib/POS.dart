import 'package:flutter/material.dart';

class POS extends StatefulWidget {
  @override
  _POSState createState() => _POSState();
}

class _POSState extends State<POS> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: AppBar(
      title: Text('Register'),
    ),
    body: Padding(padding: const EdgeInsets.all(12.0),
    child: Container(
      child: new Column(
        children: <Widget>[
          new Text('POS')
        ],
      ),
    ),),);
  }
}
