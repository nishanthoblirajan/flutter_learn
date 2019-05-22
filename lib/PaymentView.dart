//Open when payment is made for an invoice

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/DataClasses/ContactDatabase.dart';
import 'package:hello_world/DataClasses/InvoiceDatabase.dart';
import 'package:hello_world/DataClasses/LedgerDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentView extends StatefulWidget {
  ContactDatabase contactDatabase;
  InvoiceDatabase invoiceDatabase;

  @override
  _PaymentViewState createState() => _PaymentViewState();

  PaymentView({Key key,@required this.contactDatabase,@required this.invoiceDatabase}):super(key:key);
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController paymentAmountController = new TextEditingController();

  ContactDatabase contactDatabase;
  InvoiceDatabase invoiceDatabase;

  initState(){
    setState(() {
      contactDatabase = widget.contactDatabase;
      invoiceDatabase = widget.invoiceDatabase;
    });
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for Invoice #${invoiceDatabase.invoice_number}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('${contactDatabase.contact_name}\n${contactDatabase.contact_address}\n${contactDatabase.contact_phone}'),
            Text('To Pay ${invoiceDatabase.invoice_price_total}'),
            TextFormField(
              controller: paymentAmountController,
              decoration: InputDecoration(labelText: 'Payment Amount'),
              textInputAction: TextInputAction.done,
            ),
            RaisedButton(onPressed: () async {
              //TODO implement ledger entry
              var entry =  LedgerDatabase().makeEntry(roCode, contactDatabase.objectId, 'Payment for Invoice # ${invoiceDatabase.invoice_number}', 0, double.parse(paymentAmountController.text));
              entry.then((result){
                if(result){
                  Fluttertoast.showToast(msg: 'Entry Successful');
                  Navigator.pop(context);
                }else{
                  Fluttertoast.showToast(msg: 'Error');
                }
              });
              },child: Text('Make Entry'),)
          ],
        ),
      ),
    );
  }
}
