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

  AddContactScreen({Key key, @required this.contactType,@required this.contactList}) : super(key: key);
}

class _AddContactScreenState extends State<AddContactScreen> {
  String contactType;
  List<ContactDatabase> contactList;

  TextEditingController contactNameController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    contactType = widget.contactType;
    contactList = widget.contactList;
    contactNameController.text="";
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
        title: new Text('Add ' + contactType + ' Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: contactNameController,
                  decoration: InputDecoration(labelText: 'Contact Name'),
                  textInputAction: TextInputAction.next,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  addContact(roCode, contactType, contactNameController.text);
                },
                child: Text('Add Contact'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future addContact(
      String roCode, String contactType, String contactName) async {
    print('Add Contact'+roCode+" "+contactType+" "+contactName);
    ContactDatabase contactDatabase = new ContactDatabase();
    contactDatabase.ro_code = roCode;
    contactDatabase.contact_type = contactType;
    contactDatabase.contact_name = contactName;
    var found = false;
    for(int i=0;i<contactList.length;i++){
      if(contactList[i].contact_name==contactName){
        found = true;
        Fluttertoast.showToast(msg: 'Contact already present');
      }
    }
    if(!found){
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
