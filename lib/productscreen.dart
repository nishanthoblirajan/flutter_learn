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

class productscreen extends StatefulWidget {
  @override
  _productscreenState createState() => _productscreenState();
}

/*TODO show all the products added below the Add New Products Button*/

class _productscreenState extends State<productscreen> {

  @override
  initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){

          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Add New Product');
                  Navigator.pushNamed(context, '/addproductscreen');
                },
                child: Text('Add New Product'),
              ),
              Expanded(child: new FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text(loadingScreen),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return new ListTile(
                          onTap: () =>
                              _showDialog(context, _productDatabase[index]),
                          title: Text(_productDatabase[index].name),
                          subtitle: Text(
                              " Quantity: " + _productDatabase[index].quantity +
                                  " SKU: " + _productDatabase[index].sku),
                          trailing: Text(
                              "\u20B9" + _productDatabase[index].salePrice),
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  }
                },
                future: query(roCode),
              )
              ),
            ],
          ),
        ),
      ),
    );
  }


  /*Necessary Functions*/
  List<ProductDatabase> _productDatabase = [];


  query(String roCode) async {
    QueryBuilder<ParseObject> queryBuilder = QueryBuilder<ProductDatabase>(
        ProductDatabase())
      ..whereEqualTo(ProductDatabase.roCode, '12345');

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _productDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        ProductDatabase productDatabase =
        new ProductDatabase().fromJson(output);
        print(productDatabase.objectId);
        setState(() {
          _productDatabase.add(productDatabase);
        });
      }
      return _productDatabase;
    } else {
      setState(() {
        loadingScreen = "No data found";
      });
      print('Result: ${apiResponse.error.message}');
    }
  }

  _showDialog(BuildContext context, ProductDatabase productDatabase) {
    showDialog(context: context, builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text("You selected " +
            productDatabase.name),
        content: new Text(
            "SKU ${productDatabase.sku} -> ${productDatabase
                .salePrice}"),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    addproductscreen(
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
}

class ProductSearch extends SearchDelegate<String>{

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }

}
