import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addproductscreen extends StatefulWidget {
  @override
  _addproductscreenState createState() => _addproductscreenState();
}

class _addproductscreenState extends State<addproductscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                labelText: 'Product Name'
                ),
                onSubmitted: (value){
                  Fluttertoast.showToast(msg: value);
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Product SKU'
                      ),
                      onSubmitted: (value){
                        Fluttertoast.showToast(msg: value);
                      },
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: 'Scan Barcode');
                        Navigator.pushNamed(context, '/addproductscreen');
                      },
                      child: Text('Add New Product'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
