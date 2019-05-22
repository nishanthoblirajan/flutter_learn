import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'CategoryScreen.dart';
import 'DataClasses/ProductDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class addproductscreen extends StatefulWidget {
  ProductDatabase receivedProductDatabase;

  addproductscreen({Key key, this.receivedProductDatabase}) : super(key: key);

  @override
  _addproductscreenState createState() => _addproductscreenState();
}

class _addproductscreenState extends State<addproductscreen> {



  String operationType = "Add";
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

  ProductDatabase productDatabase;

  @override
  initState() {
    if (widget.receivedProductDatabase != null) {
      operationType = "Edit";
      productDatabase = widget.receivedProductDatabase;
      print('Received Product ' + productDatabase.toString());
      nameController.text = productDatabase.name;
      barcodeController.text = productDatabase.sku;
      salePriceController.text = productDatabase.salePrice;
      purchasePriceController.text = productDatabase.purchasePrice;
      quantityController.text = productDatabase.quantity.toString();
      taxCodeController.text = productDatabase.taxCode;
      taxNameController.text = productDatabase.taxName;
      sgstController.text = productDatabase.sgst;
      cgstController.text = productDatabase.cgst;
      categoryController.text = productDatabase.categoryName;
    }
    initSharedPrefs();
    super.initState();
  }

  SharedPreferences sharedPreferences;
  String roCode;

  initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      roCode = sharedPreferences.getString('ro_code');
    });
  }

  Widget productForm(){
    return Form(child: ListView(
      children: <Widget>[
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Product Name'),
          textInputAction: TextInputAction.next,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: barcodeController,
                decoration: InputDecoration(labelText: 'Product SKU'),
                textInputAction: TextInputAction.next,
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Scan Barcode');
                  barcodeScanning();
                },
                child: Text('Scan'),
              ),
            ),
          ],
        ),
        TextFormField(
          controller: salePriceController,
          decoration: InputDecoration(labelText: 'Sale Price'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: purchasePriceController,
          decoration: InputDecoration(labelText: 'Purchase Price'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: quantityController,
          decoration: InputDecoration(labelText: 'Quantity'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: taxCodeController,
          decoration: InputDecoration(labelText: 'Tax Code'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: taxNameController,
          decoration: InputDecoration(labelText: 'Tax Name'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: sgstController,
          decoration: InputDecoration(labelText: 'SGST'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          controller: cgstController,
          decoration: InputDecoration(labelText: 'CGST'),
          textInputAction: TextInputAction.next,
        ),
        RaisedButton(
          onPressed: () async {
            Map results =
            await Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => CategoryScreen(
                  categoryType: 'Product',
                  isAdmin: false,
                )));

            if (results != null &&
                results.containsKey('category_selection')) {
              setState(() {
                categoryController.text = results['category_selection'];
              });
            }
          },
          child: Text('Category'),
        ),
        Text(categoryController.text),
        buildRaisedButton(context)
      ],
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(operationType + " Product"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: productForm(),
        ),
      ),
    );
  }

  Widget buildRaisedButton(BuildContext context) {
    Widget deleteButton = RaisedButton(
      onPressed: () {
        showDialog(context: context,builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Do you want to delete?"),
            content: new Text("This cannot be undone"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  deleteProductFromDatabase(productDatabase);
                },
              ),
            ],
          );
        });
      },
      child: Text('Delete Product'),
    );

    Widget normalButton = RaisedButton(
      onPressed: () {
        addOrUpdateProduct();
      },
      child: Text(operationType + " Product"),
    );

    if (widget.receivedProductDatabase != null) {
      return Column(
        children: <Widget>[normalButton, deleteButton],
      );
    } else {
      return Column(
        children: <Widget>[normalButton],
      );
    }
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
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
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void addOrUpdateProduct() {
    if (widget.receivedProductDatabase != null) {
      updateProductToDatabase(widget.receivedProductDatabase);
    } else {
      createProductInDatabase();
    }
  }

  /*CRUD Operation Starts*/
  /*Create*/
  Future createProductInDatabase() async {
    ProductDatabase productDatabase = new ProductDatabase();
    productDatabase.name = nameController.text;
    productDatabase.ro_code = roCode;
    productDatabase.sku = barcodeController.text;
    productDatabase.salePrice = salePriceController.text;
    productDatabase.purchasePrice = purchasePriceController.text;
    productDatabase.quantity = double.parse(quantityController.text);
    productDatabase.taxCode = taxCodeController.text;
    productDatabase.taxName = taxNameController.text;
    productDatabase.sgst = sgstController.text;
    productDatabase.cgst = cgstController.text;
    productDatabase.categoryName = categoryController.text;

    var saveResponse = await productDatabase.save();
    if (saveResponse.success) {
      Fluttertoast.showToast(
          msg: 'Product Saved', backgroundColor: Colors.blue);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
    }
  }

  /*Delete*/
  Future deleteProductFromDatabase(
      ProductDatabase receivedProductDatabase) async {
    String objectID = receivedProductDatabase.get('objectId');
    print('Delete ' + objectID);
    ProductDatabase productDatabase = new ProductDatabase();
    productDatabase.set('objectId', objectID);
    print('Delete ' + productDatabase.toString());
    var deleteResponse = await productDatabase.delete();
    if (deleteResponse.success) {
      Fluttertoast.showToast(
          msg: 'Product Deleted', backgroundColor: Colors.blue);
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
    }
  }

  /*Update*/
  Future updateProductToDatabase(
      ProductDatabase receivedProductDatabase) async {
    Fluttertoast.showToast(msg: "Editing");
    String objectID = receivedProductDatabase.get('objectId');
    print('ObjectID: ' + objectID);
    ProductDatabase productDatabase = new ProductDatabase();
    productDatabase.set('objectId', objectID);
    productDatabase.name = nameController.text;
    productDatabase.sku = barcodeController.text;
    productDatabase.salePrice = salePriceController.text;
    productDatabase.purchasePrice = purchasePriceController.text;
    productDatabase.quantity = double.parse(quantityController.text);
    productDatabase.taxCode = taxCodeController.text;
    productDatabase.taxName = taxNameController.text;
    productDatabase.sgst = sgstController.text;
    productDatabase.cgst = cgstController.text;
    productDatabase.categoryName = categoryController.text;

    var saveResponse = await productDatabase.save();
    if (saveResponse.success) {
      Fluttertoast.showToast(
          msg: 'Product Updated', backgroundColor: Colors.blue);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
    }
  }
}
