import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/ContactScreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddContactScreen.dart';
import 'DataClasses/ContactDatabase.dart';

class AdminContactsScreen extends StatefulWidget {
  bool isAdmin;

  @override
  _AdminContactsScreenState createState() => _AdminContactsScreenState();

  AdminContactsScreen({Key key, @required this.isAdmin}) : super(key: key);
}

class _AdminContactsScreenState extends State<AdminContactsScreen> {
  bool isAdmin;

  TextEditingController searchTextController = new TextEditingController();

  Widget _appBarTitle;
  Icon _searchIcon = new Icon(Icons.search);
  String contactType;
  var floatingButton;

  @override
  initState() {
    isAdmin = widget.isAdmin;
    searchTextController.text = "";
    contactType = 'All';
    _appBarTitle = Text(contactType + ' Contacts');
    initSharedPrefs();
    floatingButton = FloatingActionButton.extended(
      onPressed: () async {
        Fluttertoast.showToast(msg: 'Choose Customer Type');
      },
      icon: Icon(Icons.add),
      label: Text('Add'),
    );
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


    void _searchPressed() {
      setState(() {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            controller: searchTextController,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',
            ),
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text(contactType + ' Contacts');
        }
      });
    }

    var headingBuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            print('Im Inside');
            return ListView(
                scrollDirection: Axis.horizontal, children: _getData(snapshot));
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
      future: _query(roCode, contactType, searchTextController.text),
    );


    var listBuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            print('Im Inside');
            return ListView(children: _getList(snapshot));
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
      future: _query(roCode, contactType, searchTextController.text),
    );

    return Scaffold(
      floatingActionButton: floatingButton,
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
              icon: _searchIcon,
              onPressed: () {
                _searchPressed();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(contactType),
              Container(height: 50, child: headingBuilder),
              Expanded(child: listBuilder)
            ],
          ),
        ),
      ),
    );
  }

  List<ContactDatabase> _contactDatabase = [];

  List<Widget> _getData(AsyncSnapshot snapshot) {
    List<Widget> widgetLists = new List();

    widgetLists.add(Card(
      child: InkWell(
        onTap: () {
          setState(() {
            contactType = 'All';
          });
        },
        child: Container(
          width: 160,
          child: Center(
              child: Text(
                'All',
                textAlign: TextAlign.center,
              )),
        ),
      ),
    ));
    widgetLists.add(Card(
      child: InkWell(
        onTap: () {
          setState(() {
            contactType = 'Customer';
          });
        },
        child: Container(
          width: 160,
          child: Center(
              child: Text(
                'Customer',
                textAlign: TextAlign.center,
              )),
        ),
      ),
    ));
    widgetLists.add(Card(
      child: InkWell(
        onTap: () {
          setState(() {
            contactType = 'Vendor';
          });
        },
        child: Container(
          width: 160,
          child: Center(
              child: Text(
                'Vendor',
                textAlign: TextAlign.center,
              )),
        ),
      ),
    ));
    return widgetLists;
  }

  List<Widget> _getList(AsyncSnapshot snapshot) {
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
      widgetLists.add(Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(_contactDatabase[index].contact_name),
              onTap: () {
                //TODO open contact name editing
              },
            ),
          new Row(mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(onPressed: (){
              editContact(_contactDatabase[index]);
            }, child: new Text('Edit')),
            new FlatButton(onPressed: (){

              showDialog(context: context,builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text("Do you want to delete?"),
                  content: new Text("This cannot be undone"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Yes"),
                      onPressed: () {
                        deleteObjectFromDatabase(_contactDatabase[index]);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
              /*TODOCompleted Implement Delete*/
            }, child: new Text('Delete', style: new TextStyle(color:Colors.redAccent),)),
          ],)],
        ),
      ));
    }
    return widgetLists;
  }

  deleteObjectFromDatabase(ParseObject object) async {
    ParseObject deleteObject = object;
    var delete = await deleteObject.delete();
    if(delete.success){
      Fluttertoast.showToast(msg: 'Deleted');
    }else{
      Fluttertoast.showToast(msg: 'Unable to Delete. Contact Developer');
    }
  }
  editContact(ContactDatabase contactDatabase){
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) =>
            AddContactScreen(
              contactType: contactType,
              contactList: _contactDatabase,
              isEdit: true,
              contactToEdit: contactDatabase,
            )));
  }

  _query(String roCode, String contactType, String textSearch) async {
    QueryBuilder<ParseObject> queryBuilder;

    if (contactType == 'All') {
      setState(() {
        floatingButton = FloatingActionButton.extended(
          onPressed: () async {
            Fluttertoast.showToast(msg: 'Choose Customer Type');
          },
          icon: Icon(Icons.add),
          label: Text('Add'),
        );
      });
      queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
        ..whereEqualTo(ContactDatabase.roCode, roCode);
    } else {
      setState(() {
        floatingButton = FloatingActionButton.extended(
          onPressed: () async {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    AddContactScreen(
                      contactType: contactType,
                      contactList: _contactDatabase,
                    )));
          },
          icon: Icon(Icons.add),
          label: Text('Add'),
        );
      });
      queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
        ..whereEqualTo(ContactDatabase.roCode, roCode)
        ..whereEqualTo(ContactDatabase.contactType, contactType);
    }
    if (textSearch == "") {
    } else {
      queryBuilder = queryBuilder
        ..whereContains(ContactDatabase.contactName, textSearch);
    }

    QueryBuilder<ParseObject> allQueriesForContactTypeList =
        QueryBuilder<ContactDatabase>(ContactDatabase())
          ..whereEqualTo(ContactDatabase.roCode, roCode);
    ParseResponse apiResponse = await allQueriesForContactTypeList.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _contactDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        Map output = json.decode(listFromApi[i].toString());
        ContactDatabase contactDatabase =
            new ContactDatabase().fromJson(output);
        print(contactDatabase.contact_name);
      }
    }
    return queryBuilder.query();
  }

}
