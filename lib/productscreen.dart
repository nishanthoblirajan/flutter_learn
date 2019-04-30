import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/layouts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class productscreen extends StatefulWidget {
  @override
  _productscreenState createState() => _productscreenState();
}

class _productscreenState extends State<productscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Add New Product');
                    Navigator.pushNamed(context, '/addproductscreen');
                  },
                  child: Text('Add New Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
