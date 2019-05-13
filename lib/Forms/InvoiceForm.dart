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
                setState(() {
                  getProductFromID(results['product_selection']);
                  _quantity.add(results['quantity_selection']);
                });
              }
            },
            child: new Text(('Add Products')),
          ),
          /*TODO implement data table calculation*/
          Expanded (
            child: DataTable(columns: <DataColumn>[
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Quantity')),
//              DataColumn(label: Text('Tax')),
              DataColumn(label: Text('MRP')),
              DataColumn(label: Text('Total')),
            ], rows: List.generate(_selectedProductDatabase.length, (index){
              return DataRow(cells: <DataCell>[
                DataCell(Text(_selectedProductDatabase[index].name)),
                DataCell(Text(_quantity[index])),
//                DataCell(Text(_selectedProductDatabase[index].taxName)),
                DataCell(Text(_selectedProductDatabase[index].salePrice)),
                DataCell(calculateTotal(_quantity[index],_selectedProductDatabase[index].salePrice)),
              ]);
            })

            ),
          )
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
    double total = doubleQuantity*doubleSalePrice;
    return Text('₹$total');
  }

}
