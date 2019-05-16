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
    _query(roCode, 0);
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
      //TODO 16/05/2019 -> TextEditingController should come for the _query(roCode,[])
      future: _query(roCode, 0),

//      future: _query(roCode, invoiceSearchController.text),
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
        Map output = json.decode(listFromApi[i].toString());
        InvoiceDatabase invoiceDatabase =
        new InvoiceDatabase().fromJson(output);
        print(invoiceDatabase.invoice_number);
        _invoiceDatabase.add(invoiceDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for(int i=0;i<_invoiceDatabase.length;i++){
      _invoiceNumbers.add(_invoiceDatabase[i].invoice_number);
      _invoiceAmounts.add(_invoiceDatabase[i].invoice_price_total);
    }

    Set<num> invoiceNumbers = LinkedHashSet.from(_invoiceNumbers);
    /*TODO 17/05/2019 get InvoicePriceAmount value using the InvoiceNumbers*/

    print('The length is ${invoiceNumbers.length}');

    for (int i = 0; i < invoiceNumbers.length; i++) {
      widgetLists.add(ListTile(
        title: Text('# ${invoiceNumbers.elementAt(i)}'),
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) =>
                  InvoiceView(
                    invoiceNumber: invoiceNumbers.elementAt(i),
                  )));
        },
        trailing: Text(
            'TODO'),
      ));
    }

    return widgetLists;
  }

  List<InvoiceDatabase> _invoiceDatabase = [];
  List<num> _invoiceNumbers=[];
  List<String> _invoiceAmounts=[];

  _query(String roCode, num invoiceSearch) async {
    QueryBuilder<ParseObject> queryBuilder;
    if (invoiceSearch<=0) {
      print('query is choice 1');
      queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
        ..whereEqualTo(InvoiceDatabase.roCode, roCode);
    } else {
      print('query is choice 2');
      queryBuilder = QueryBuilder<InvoiceDatabase>(InvoiceDatabase())
        ..whereEqualTo(InvoiceDatabase.roCode, roCode)
        ..whereEqualTo(InvoiceDatabase.keyInvoiceNumber, invoiceSearch);
    }
    return queryBuilder.query();
  }
}
