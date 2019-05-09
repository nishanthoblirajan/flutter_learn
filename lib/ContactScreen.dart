import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/AddContactScreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataClasses/ContactDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ContactScreen extends StatefulWidget {
  String contactType;

  bool isAdmin;
  @override
  _ContactScreenState createState() => _ContactScreenState();

  ContactScreen({Key key, @required this.contactType, this.isAdmin}) : super(key: key);
}

class _ContactScreenState extends State<ContactScreen> {
  String contactType;

  bool isAdmin;

  TextEditingController searchTextController = new TextEditingController();



  /*Use normal listview after setting the query in initState*/
  @override
  initState() {
    isAdmin = widget.isAdmin;
    contactType = widget.contactType;
    searchTextController.text = "";
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

    var futurebuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if(snapshot.hasData){
          if(snapshot.data!=null){
            print('Im Inside');
            return ListView(children:
            _getData(snapshot));
          }else{
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        }else{
          return Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
      future: _query(roCode, contactType, searchTextController.text),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          /*TODO add new contact name*/
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
                  AddContactScreen(
                    contactType: 'Customer',
                    contactList: _contactDatabase,
                  )));
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      appBar: AppBar(
        title: new Text(contactType + ' Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: new Column(
            children: <Widget>[
              Expanded(child: futurebuilder),
            ],
          ),
        ),
      ),
    );
  }

  List<ContactDatabase> _contactDatabase = [];



  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _contactDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        Map output = json.decode(listFromApi[i].toString());
        ContactDatabase contactDatabase =
        new ContactDatabase().fromJson(output);
        print(contactDatabase.contact_name);
        _contactDatabase.add(contactDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _contactDatabase.length; index++) {
      widgetLists.add(ListTile(
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if(isAdmin){
              deleteContactFromDatabase(_contactDatabase[index]);
            }else{
              Fluttertoast.showToast(msg: 'Require Admin');
            }

          },
        ),
        title: Text(_contactDatabase[index].contact_name),
        onTap: () {
          sharedPreferences.setString(contactType + "_contact",
              _contactDatabase[index].contact_name);
          Navigator.of(context).pop({
            'contact_selection':
            _contactDatabase[index].contact_name
          });
        },
      ));
    }
    return widgetLists;
  }

}

/*TODO 09/05/2019 implement contact screen search*/
_query(String roCode, String contactType, String textSearch) async {
  QueryBuilder<ParseObject> queryBuilder;
  if (textSearch == "") {
    queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
      ..whereEqualTo(ContactDatabase.roCode, roCode)..whereEqualTo(
          ContactDatabase.contactType, contactType);
  } else {
    queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
      ..whereEqualTo(ContactDatabase.roCode, roCode)..whereEqualTo(
          ContactDatabase.contactType, contactType)..whereContains(
          ContactDatabase.contactName, textSearch);
  }
  return queryBuilder.query();
}

/*Delete*/
Future deleteContactFromDatabase(
    ContactDatabase receivedContactDatabase) async {
  String objectID = receivedContactDatabase.get('objectId');
  print('Delete ' + objectID);
  ContactDatabase contactDatabase = new ContactDatabase();
  contactDatabase.set('objectId', objectID);
  print('Delete ' + contactDatabase.toString());
  var deleteResponse = await contactDatabase.delete();
  if (deleteResponse.success) {
    Fluttertoast.showToast(
        msg: 'Customer Deleted', backgroundColor: Colors.blue);
  } else {
    Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
  }
}
