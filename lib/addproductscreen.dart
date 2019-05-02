import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class addproductscreen extends StatefulWidget {

  @override
  _addproductscreenState createState() => _addproductscreenState();
}

class _addproductscreenState extends State<addproductscreen> {
  String barcode = "";
  TextEditingController barcodeController = new TextEditingController();

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
                      controller: barcodeController,
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
                        barcodeScanning();
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
  Future barcodeScanning() async {
//imageSelectorGallery();

    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode=barcode;
        barcodeController.text = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
