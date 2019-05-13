import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/ContactScreen.dart';
import 'package:hello_world/DataClasses/ProductDatabase.dart';
import 'package:hello_world/DataClasses/RODatabase.dart';
import 'package:hello_world/productscreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceForm extends StatefulWidget {
  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  String invoiceNumber;
  RODatabase roDatabase;

  SharedPreferences sharedPreferences;
  String roCode;

  initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      roCode = sharedPreferences.getString('ro_code');
    });
  }

  initRODatabase() async {
    _getRODatabase(roCode).then((value) {
      _roList = value;
      for (int i = 0; i < _roList.length; i++) {
        if (_roList[i].ro_code == roCode) {
          roDatabase = _roList[i];
          print('RO ---> ' + roDatabase.toString());
        }
      }
      setState(() {
        invoiceNumber = roDatabase.invoice_number;
      });
    });
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  initState() {
    invoiceNumber = 'N/A';
    _quantity = new List();
    _selectedProductDatabase = new List();
    initSharedPrefs();
    initRODatabase();
    super.initState();
  }

  TextEditingController contactNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            calculateListTotal(_quantity, _selectedProductDatabase),
            style: TextStyle(fontSize: 20),
          ),
          new Text('Invoice #' + invoiceNumber),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ),
              Expanded(
                  child: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                textAlign: TextAlign.center,
              )),
            ],
          ),
          new TextFormField(
            controller: contactNameController,
            decoration: new InputDecoration(labelText: 'Contact Name'),
          ),
          new RaisedButton(
            onPressed: () async {
              /*TODO add choose contact
              * Implement activity for result here*/
              Fluttertoast.showToast(msg: 'Add Contact');

              Map results =
                  await Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => ContactScreen(
                            contactType: 'Customer',
                            isAdmin: false,
                          )));

              if (results != null && results.containsKey('contact_selection')) {
                setState(() {
                  contactNameController.text = results['contact_selection'];
                });
              }
            },
            child: new Text('Choose'),
          ),
          new RaisedButton(
            onPressed: () async {
              Map results =
                  await Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => productscreen(
                            fromInvoice: true,
                          )));

              if (results != null && results.containsKey('product_selection')) {
                getProductFromID(results['product_selection']);
                setState(() {
                  _quantity.add(results['quantity_selection']);
                });
              }
            },
            child: new Text(('Add Products')),
          ),
          /*TODO implement data table calculation*/
          Flexible(
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                      label: Expanded(
                    child: Container(child: Text('Name')),
                    flex: 2,
                  )),
                  DataColumn(
                      label: Expanded(
                          child: Container(child: Text('Quantity')), flex: 1)),
//              DataColumn(label: Text('Tax')),
                  DataColumn(
                      label: Expanded(
                    child: Container(child: Text('MRP')),
                    flex: 1,
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Container(child: Text('Total')),
                    flex: 3,
                  )),
                ],
                /*TODO error
                * Another exception was thrown: RangeError (index): Invalid value: Not in range 0..2, inclusive: 3*/
                rows: List.generate(_selectedProductDatabase.length, (index) {
                  return DataRow(cells: <DataCell>[
//                    DataCell(IconButton(
//                        icon: Icon(Icons.clear),
//                        onPressed: () {
//                          setState(() {
//                            _selectedProductDatabase.removeAt(index);
//
//                            _quantity.removeAt(index);
//                          });
//                        })),
                    DataCell(Text(_selectedProductDatabase[index].name)),
                    DataCell(Text(_quantity[index])),
//                DataCell(Text(_selectedProductDatabase[index].taxName)),
                    DataCell(Text(_selectedProductDatabase[index].salePrice)),
                    DataCell(calculateTotal(_quantity[index],
                        _selectedProductDatabase[index].salePrice)),
                  ]);
                })),
          ),
        ],
      ),
    );
  }

  Future<void> getProductFromID(String objectID) async {
    ParseResponse apiResponse = await ProductDatabase().getObject(objectID);

    if (apiResponse.success && apiResponse.count > 0) {
      ProductDatabase productDatabase = apiResponse.result;
      setState(() {
        _selectedProductDatabase.add(productDatabase);
      });
      return productDatabase;
    } else {
      print(keyAppName + ': ' + apiResponse.error.message);
    }
  }

  List<ProductDatabase> _selectedProductDatabase = [];
  List<String> _quantity = [];
  List<RODatabase> _roList = [];

  Future<List<RODatabase>> _getRODatabase(String roCode) async {
    List<RODatabase> roDatabaseList;
    QueryBuilder<ParseObject> queryBuilder;
    queryBuilder = QueryBuilder<RODatabase>(RODatabase());
    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      roDatabaseList = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        Map output = json.decode(listFromApi[i].toString());
        RODatabase roDatabase = new RODatabase().fromJson(output);
        print(roDatabase.toString());
        roDatabaseList.add(roDatabase);
      }
    }
    return roDatabaseList;
  }

  /*TODO add rupee symbol and finish InvoiceDatabase*/
  Widget calculateTotal(String quantity, String salePrice) {
    double doubleQuantity = double.parse(quantity);
    double doubleSalePrice = double.parse(salePrice);
    double total = doubleQuantity * doubleSalePrice;
    return Text('₹$total');
  }

  String calculateListTotal(
      List<String> quantity, List<ProductDatabase> selectedProductDatabase) {
    double total = 0;
    for (int i = 0; i < quantity.length; i++) {
      double doubleQuantity = double.parse(quantity[i]);
      double doubleSalePrice =
          double.parse(selectedProductDatabase[i].salePrice);
      total += doubleQuantity * doubleSalePrice;
    }
    return '₹$total';
  }
}
