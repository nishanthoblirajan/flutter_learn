import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/DataClasses/ContactDatabase.dart';
import 'package:hello_world/DataClasses/InvoiceDatabase.dart';
import 'package:hello_world/DataClasses/LedgerDatabase.dart';
import 'package:hello_world/PaymentView.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceView extends StatefulWidget {
  num invoiceNumber;

  @override
  _InvoiceViewState createState() => _InvoiceViewState();

  InvoiceView({Key key, @required this.invoiceNumber}) : super(key: key);
}

/*TODO 17/05/2019 display all relevant invoice details such as
* Contact
* Contact Address
* Products
* Tax
* Total
* Print Button for pdf generation*/
class _InvoiceViewState extends State<InvoiceView> {
  num invoiceNumber;
  SharedPreferences sharedPreferences;
  String roCode;

  ContactDatabase invoiceContact = new ContactDatabase();

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

  Future<void> getContactFromID(String objectID) async {
    ParseResponse apiResponse = await ContactDatabase().getObject(objectID);

    if (apiResponse.success && apiResponse.count > 0) {
      setState(() {
        invoiceContact = apiResponse.result;

      });
    } else {
      print(keyAppName + ': ' + apiResponse.error.message);
    }
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
                Text(
                    '${invoiceContact.contact_name}\n${invoiceContact.contact_address}\n${invoiceContact.contact_phone}'),
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
                                child: Container(child: Text('Quantity')),
                                flex: 1)),
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
                      rows: List.generate(_invoiceDatabase.length, (index) {
                        return DataRow(cells: <DataCell>[
                          DataCell(Text(_invoiceDatabase[index].product_name)),
                          DataCell(Text(
                              '${_invoiceDatabase[index].product_quantity}')),
                          DataCell(
                              Text(_invoiceDatabase[index].product_price_MRP)),
                          DataCell(Text(
                              _invoiceDatabase[index].product_price_total)),
                        ]);
                      })),
                ),
                RaisedButton(
                  onPressed: () {
                    showPaymentView(invoiceContact, _invoiceDatabase[0]);
                  },
                  child: Text('Make Payment'),
                ),
                Text('Corresponding Payments'),
                Container(
                  child: FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      print('snapshot is ${snapshot.toString()}');
                      if(snapshot.connectionState==ConnectionState.done){
                        print('snapshot data is ${snapshot.data.toString()}');
                        return LedgerDatabase().buildData(snapshot.data);
                      }
                    }else{
                      return new CircularProgressIndicator();
                    }

                  },future: LedgerDatabase().checkEntry(roCode, invoiceContact.objectId, 'Payment for Invoice # $invoiceNumber'),),
                )
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
        Map output = json.decode(listFromApi[i].toString());
        InvoiceDatabase invoiceDatabase =
            new InvoiceDatabase().fromJson(output);

        print('To String of the invoice ' + invoiceDatabase.toString());
        setState(() {
          _invoiceDatabase.add(invoiceDatabase);
          getContactFromID(invoiceDatabase.contact_id);
        });
      }
    }
  }




  void showPaymentView(
      ContactDatabase contactDatabase, InvoiceDatabase invoiceDatabase) {
    print('InvoiceView Contact ${invoiceContact.contact_name}');
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => PaymentView(
              contactDatabase: invoiceContact,
              invoiceDatabase: invoiceDatabase,
            )));
  }
}
