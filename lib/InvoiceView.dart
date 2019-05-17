import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/DataClasses/InvoiceDatabase.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceView extends StatefulWidget {
  num invoiceNumber;

  @override
  _InvoiceViewState createState() => _InvoiceViewState();

  InvoiceView({Key key, @required this.invoiceNumber}) : super(key: key);
}

class _InvoiceViewState extends State<InvoiceView> {
  num invoiceNumber;
  SharedPreferences sharedPreferences;
  String roCode;

  initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null) {
      print('sharedPreference is available');
      setState(() {
        roCode = sharedPreferences.getString('ro_code');
        print('roCode $roCode invoiceNumber $invoiceNumber');
        //getting the query as soon as we get the roCode.
        //placing the query in the initState after iniSharedPrefs and invoiceNumber
        //receives null for the roCode
        _getInvoiceDetails(roCode, invoiceNumber);
      });
    }
  }

  @override
  void initState() {
    print('initState');
    initSharedPrefs();
    invoiceNumber = widget.invoiceNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Invoice # $invoiceNumber'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Flexible(child: DataTable(
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
                    rows: List.generate(_invoiceDatabase.length, (index) {
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
                        DataCell(Text(_invoiceDatabase[index].product_name)),
                        DataCell(Text(_invoiceDatabase[index].product_quantity)),
//                DataCell(Text(_selectedProductDatabase[index].taxName)),
                        DataCell(Text(_invoiceDatabase[index].product_price_MRP)),
                        DataCell(Text(_invoiceDatabase[index].product_price_total)),
                      ]);
                    }))),
              ],
            ),
          ),
        ));
  }

  List<InvoiceDatabase> _invoiceDatabase = [];

  _getInvoiceDetails(String roCode, num invoiceNumber) async {
    print('quering...  Invoice Number $invoiceNumber');
    QueryBuilder<ParseObject> queryBuilder;
    queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
      ..whereEqualTo(InvoiceDatabase.roCode, roCode)
      ..whereEqualTo('invoice_number', invoiceNumber);
    ParseResponse apiResponse = await queryBuilder.query();
    print('Result ====> ${apiResponse.success}');
    if (apiResponse.success) {
      print(
          'Im inside the loop getting the invoice details in InvoiceView Dart File');
      final List<ParseObject> listFromApi = apiResponse.result;
      _invoiceDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
//        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        InvoiceDatabase invoiceDatabase =
            new InvoiceDatabase().fromJson(output);
        print('To String of the invoice ' + invoiceDatabase.toString());
        setState(() {
          _invoiceDatabase.add(invoiceDatabase);
        });
      }
    }
  }
}
