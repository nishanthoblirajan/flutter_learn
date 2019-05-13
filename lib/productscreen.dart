import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/layouts.dart';
import 'package:hello_world/addproductscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ApplicationConstants.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'DataClasses/ProductDatabase.dart';
import 'dart:convert';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class productscreen extends StatefulWidget {
  /*TODO implement Add Products from InvoiceForm*/
  bool fromInvoice;

  @override
  _productscreenState createState() => _productscreenState();

  productscreen({Key key, this.fromInvoice}) : super(key: key);
}

class _productscreenState extends State<productscreen> {
  TextEditingController searchTextController = new TextEditingController();
  TextEditingController barcodeTextController = new TextEditingController();

  String scanText;
  bool fromInvoice;

  @override
  initState() {

    fromInvoice = widget.fromInvoice;
    if(fromInvoice==null){
      fromInvoice=false;
    }
    scanText = 'Scan';
    searchTextController.text = "";
    barcodeTextController.text = "";
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

  String loadingScreen = "Loading...";

  Widget _appBarTitle = new Text('Products');
  Icon _searchIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    /*change only the future*/
    var futurebuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            print('Im Inside');
            return ListView(children: _getData(snapshot));
          } else {
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
      future:
          _query(roCode, searchTextController.text, barcodeTextController.text),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sharedPreferences.setString('Product_category', '');
          Navigator.pushNamed(context, '/addproductscreen');
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
              icon: _searchIcon,
              onPressed: () {
                _searchPressed();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _barcodeScanning();
                      },
                      child: Text(scanText),
                    ),
                  ),
                ],
              ),
              Expanded(child: futurebuilder),
            ],
          ),
        ),
      ),
    );
  }

  /*Necessary Functions*/
  List<ProductDatabase> _productDatabase = [];

  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _productDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        ProductDatabase productDatabase =
            new ProductDatabase().fromJson(output);
        print(productDatabase.name);
        _productDatabase.add(productDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _productDatabase.length; index++) {
      widgetLists.add(ListTile(
        onTap: () {
          if (fromInvoice) {
            print('from Invoice');
            _displayQuantityDialog(context,index);
          } else {
            print('not from Invoice');
            _showDialog(context, _productDatabase[index]);
          }
        },
        title: Text(_productDatabase[index].name),
        subtitle: Text(" Quantity: " +
            _productDatabase[index].quantity +
            " SKU: " +
            _productDatabase[index].sku),
        trailing: Text("\u20B9" + _productDatabase[index].salePrice),
      ));
    }
    return widgetLists;
  }

  _query(String roCode, String textSearch, String barCodeSearch) async {
    QueryBuilder<ParseObject> queryBuilder;
    if (textSearch == "" && barCodeSearch == "") {
      queryBuilder = QueryBuilder<ProductDatabase>(ProductDatabase())
        ..whereEqualTo(ProductDatabase.roCode, roCode);
    } else if (textSearch != "" && barCodeSearch == "") {
      queryBuilder = QueryBuilder<ProductDatabase>(ProductDatabase())
        ..whereEqualTo(ProductDatabase.roCode, roCode)
        ..whereContains(ProductDatabase.keyName, textSearch);
    } else if (textSearch == "" && barCodeSearch != "") {
      queryBuilder = QueryBuilder<ProductDatabase>(ProductDatabase())
        ..whereEqualTo(ProductDatabase.roCode, roCode)
        ..whereContains(ProductDatabase.keySKU, barCodeSearch);
    }
    return queryBuilder.query();
  }

  _showDialog(BuildContext context, ProductDatabase productDatabase) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("You selected " + productDatabase.name),
            content: new Text(
                "SKU ${productDatabase.sku} -> ${productDatabase.salePrice}"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => addproductscreen(
                                  receivedProductDatabase: productDatabase,
                                )));
                  },
                  child: new Text("Edit")),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Close"))
            ],
          );
        });
  }

  TextEditingController quantityController = new TextEditingController();

  _displayQuantityDialog(BuildContext context,int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Quantity'),
            content: TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: "Enter Quantity"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pop({'product_selection': _productDatabase[index].objectId,'quantity_selection':quantityController.text});                },
              )
            ],
          );
        });
  }

  /*TODO test barcode scanning*/
  Future _barcodeScanning() async {
    if (scanText != 'Clear') {
      try {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          scanText = 'Clear';
          barcodeTextController.text = barcode;
        });
        Fluttertoast.showToast(msg: "Searching Barcode " + barcode);
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
        } else {}
      } on FormatException {} catch (e) {}
    } else {
      setState(() {
        scanText = 'Scan';
        barcodeTextController.text = '';
        Fluttertoast.showToast(msg: 'Cleared');
      });
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: searchTextController,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...',
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Products');
      }
    });
  }
}
