import 'package:flutter/material.dart';

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
      body: Container(
        child: Text('Add Product Screen'),
      ),
    );
  }
}
