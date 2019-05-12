import 'package:flutter/material.dart';
import 'package:hello_world/Forms/InvoiceForm.dart';

class AddInvoiceScreen extends StatefulWidget {
  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InvoiceForm(),
      ),
    );
  }
}
