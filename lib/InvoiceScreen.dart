import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddInvoiceScreen.dart';
import 'DataClasses/InvoiceDatabase.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  TextEditingController invoiceSearchController = new TextEditingController();

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

  TextEditingController contactNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      _query(roCode, invoiceSearchController.text),
    );
    
    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Fluttertoast.showToast(msg: 'New Invoice');

            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => AddInvoiceScreen()));

        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      appBar: AppBar(
      title: Text('Invoice'),
    ),
      body: Padding(padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: futurebuilder),

                ],
              ),
            ],
          ),
        ),),);
  }
  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _invoiceDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        InvoiceDatabase invoiceDatabase =
        new InvoiceDatabase().fromJson(output);
        print(invoiceDatabase.invoice_number);
        _invoiceDatabase.add(invoiceDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _invoiceDatabase.length; index++) {
      widgetLists.add(ListTile(
        title: Text("# "+_invoiceDatabase[index].invoice_number),
        subtitle: Text(_invoiceDatabase[index].contact_id),
      ));
    }
    return widgetLists;
  }

  //TODO implement invoice screen
  List<InvoiceDatabase> _invoiceDatabase = [];

  _query(String roCode, String invoiceSearch) async {
    QueryBuilder<ParseObject> queryBuilder;
    if (invoiceSearch == "") {
      queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
        ..whereEqualTo(InvoiceDatabase.roCode, roCode);
    } else {
      queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
        ..whereEqualTo(InvoiceDatabase.roCode, roCode)
        ..whereContains(InvoiceDatabase.invoiceNumber, invoiceSearch);
    } 
    return queryBuilder.query();
  }
}
