import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddInvoiceScreen.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

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
                  new Text('New Invoice',
                  textAlign: TextAlign.center,)
                ],
              ),
            ],
          ),
        ),),);
  }
}
