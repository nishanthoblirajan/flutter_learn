import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/DataClasses/InvoiceDatabase.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceView extends StatefulWidget {
  String invoiceNumber;
  @override
  _InvoiceViewState createState() => _InvoiceViewState();

  InvoiceView({Key key, @required this.invoiceNumber}):super(key:key);
}

class _InvoiceViewState extends State<InvoiceView> {

  String invoiceNumber;
  SharedPreferences sharedPreferences;
  String roCode;

  initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      roCode = sharedPreferences.getString('ro_code');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    initSharedPrefs();

    invoiceNumber = widget.invoiceNumber;
    _getInvoiceDetails(invoiceNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Invoice # '+invoiceNumber),
      ),
      body: Padding(padding: const EdgeInsets.all(12.0),
      child: Text('$_invoiceDatabase'))
    );
  }


  List<InvoiceDatabase> _invoiceDatabase=[];
  _getInvoiceDetails(String invoiceNumber) async{
    QueryBuilder<ParseObject> queryBuilder;
    queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
      ..whereEqualTo(InvoiceDatabase.roCode, roCode)
      ..whereContains(InvoiceDatabase.invoiceNumber, invoiceNumber);
    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _invoiceDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
//        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        InvoiceDatabase invoiceDatabase =
        new InvoiceDatabase().fromJson(output);
        print(invoiceDatabase.invoice_number);
        _invoiceDatabase.add(invoiceDatabase);
      }
    }
  }
}
