import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/ContactScreen.dart';
import 'package:hello_world/DataClasses/RODatabase.dart';
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
          )
        ],
      ),
    );
  }

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
}
