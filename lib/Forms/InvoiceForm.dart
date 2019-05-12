import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/ContactScreen.dart';

class InvoiceForm extends StatefulWidget {
  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}


class _InvoiceFormState extends State<InvoiceForm> {
  TextEditingController contactNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new Text('New Invoice'),
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

              if (results != null &&
                  results.containsKey('contact_selection')) {
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
}
