import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataClasses/ContactDatabase.dart';

class AddContactScreen extends StatefulWidget {
  String contactType;
  List<ContactDatabase> contactList;

  @override
  _AddContactScreenState createState() => _AddContactScreenState();

  AddContactScreen(
      {Key key, @required this.contactType, @required this.contactList})
      : super(key: key);
}

class _AddContactScreenState extends State<AddContactScreen> {
  String contactType;
  List<ContactDatabase> contactList;

  TextEditingController contactNameController = new TextEditingController();
  TextEditingController contactAddressController = new TextEditingController();
  TextEditingController contactPhoneNumberController = new TextEditingController();

  TextEditingController contactBusinessNameController= new TextEditingController();
  TextEditingController contactGSTController= new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    contactType = widget.contactType;
    contactList = widget.contactList;
    contactNameController.text = "";
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

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();



  Widget contactForm(){
    return Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          children: <Widget>[
            TextFormField(
              controller: contactBusinessNameController,
              decoration: InputDecoration(labelText: 'Business Name'),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: contactNameController,
              decoration: InputDecoration(labelText: 'Name'),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: contactAddressController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Address'),
              keyboardType: TextInputType.text,

            ),
            TextFormField(
              controller: contactPhoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: contactGSTController,
              decoration: InputDecoration(labelText: 'GST'),
              keyboardType: TextInputType.text,
              maxLength: 15,
            ),
            RaisedButton(
              onPressed: () {
                addContact(roCode, contactType, contactNameController.text);
              },
              child: Text('Add Contact'),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Add ' + contactType + ' Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: contactForm(),
        ),
      ),
    );
  }

  Future addContact(
      String roCode, String contactType, String contactName) async {
    print('Add Contact' + roCode + " " + contactType + " " + contactName);
    ContactDatabase contactDatabase = new ContactDatabase();
    contactDatabase.ro_code = roCode;
    contactDatabase.contact_type = contactType;
    contactDatabase.contact_business = contactBusinessNameController.text;
    contactDatabase.contact_name = contactName;
    contactDatabase.contact_address=contactAddressController.text;
    contactDatabase.contact_phone=contactPhoneNumberController.text;
    contactDatabase.contact_gst=contactGSTController.text;
    var found = false;
    for (int i = 0; i < contactList.length; i++) {
      if (contactList[i].contact_name == contactName) {
        found = true;
        Fluttertoast.showToast(msg: 'Contact already present');
      }
    }
    if (!found) {
      var saveResponse = await contactDatabase.save();

      if (saveResponse.success) {
        Fluttertoast.showToast(
            msg: 'Contact Saved', backgroundColor: Colors.blue);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
      }
    }
  }
}
