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
  TextEditingController nameController = new TextEditingController();
  TextEditingController barcodeController = new TextEditingController();
  TextEditingController salePriceController = new TextEditingController();
  TextEditingController purchasePriceController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController taxCodeController = new TextEditingController();
  TextEditingController taxNameController = new TextEditingController();
  TextEditingController sgstController = new TextEditingController();
  TextEditingController cgstController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                  labelText: 'Product Name'

                  ),
                  textInputAction: TextInputAction.next,

                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: barcodeController,
                        decoration: InputDecoration(
                            labelText: 'Product SKU'
                        ),
                        textInputAction: TextInputAction.next,

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
                ),
                TextFormField(
                  controller: salePriceController,
                  decoration: InputDecoration(
                      labelText: 'Sale Price'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: purchasePriceController,
                  decoration: InputDecoration(
                      labelText: 'Purchase Price'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                      labelText: 'Quantity'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: taxCodeController,
                  decoration: InputDecoration(
                      labelText: 'Tax Code'
                  ),

                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: taxNameController,
                  decoration: InputDecoration(
                      labelText: 'Tax Name'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: sgstController,
                  decoration: InputDecoration(
                      labelText: 'SGST'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: cgstController,
                  decoration: InputDecoration(
                      labelText: 'CGST'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                      labelText: 'Category'
                  ),
                  textInputAction: TextInputAction.next,

                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      addProductToDatabase();
                    },
                    child: Text('Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future barcodeScanning() async {
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

  void addProductToDatabase() {

  }
}
