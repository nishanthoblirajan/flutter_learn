import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/DataClasses/ContactDatabase.dart';
import 'package:hello_world/DataClasses/ProductDatabase.dart';
import 'package:hello_world/InvoiceView.dart';
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
    _query(roCode, '');
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
      future: _query(roCode, invoiceSearchController.text),
    );

    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Fluttertoast.showToast(msg: 'New Invoice');

          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => AddInvoiceScreen()));
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: futurebuilder),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
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

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _invoiceDatabase.length; index++) {
      _invoiceNumber.add(_invoiceDatabase[index].invoice_number);
    }

    HashSet<String> hashSet = new HashSet<String>();
    hashSet.addAll(_invoiceNumber);
    for (int i = 0; i < hashSet.length; i++) {
      print('hashSet.length ---> ${hashSet.length}');
      widgetLists.add(ListTile(
        title: Text('# ${hashSet.elementAt(i)}'),
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => InvoiceView(
                invoiceNumber: hashSet.elementAt(i),
              )));
        },
/*TODO calculate total in _getInvoiceDetails*/

//        subtitle: Text(_invoiceDatabase[index].contact_id),
//        leading: Text(_invoiceDatabase[index].invoice_date),
//        trailing: Text(_invoiceDatabase[index].product_id),
      ));
    }

    return widgetLists;
  }

  //TODO implement invoice screen
  List<InvoiceDatabase> _invoiceDatabase = [];

  List<String> _invoiceNumber = [];

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
