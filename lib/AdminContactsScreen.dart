import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/ContactScreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataClasses/ContactDatabase.dart';

class AdminContactsScreen extends StatefulWidget {
  bool isAdmin;
  @override
  _AdminContactsScreenState createState() => _AdminContactsScreenState();

  AdminContactsScreen({Key key,  @required this.isAdmin}) : super(key: key);


}

class _AdminContactsScreenState extends State<AdminContactsScreen> {

  bool isAdmin;

  TextEditingController searchTextController = new TextEditingController();

  Widget _appBarTitle;
  Icon _searchIcon = new Icon(Icons.search);
    String contactType;
  @override
  initState() {
    isAdmin = widget.isAdmin;
    searchTextController.text = "";
    contactType = 'All';
    _appBarTitle = new Text(contactType+' Contacts');
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

    var futurebuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if(snapshot.hasData){
          if(snapshot.data!=null){
            print('Im Inside');
            return ListView(
                scrollDirection: Axis.horizontal,children:
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
      widgetLists.add(Container(
        width: 160.0,
        height: 120.0,
        child: ListTile(
          title: Text(_contactDatabase[index].contact_name),
          onTap: () {
            setState(() {
              contactType=_contactDatabase[index].contact_type;
            });
          },
        ),
      ));
    }
    return widgetLists;
  }


  _query(String roCode, String contactType, String textSearch) async {
    QueryBuilder<ParseObject> queryBuilder;

    if(contactType=='All'){
      queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
        ..whereEqualTo(ContactDatabase.roCode, roCode);
    }else{
      queryBuilder = QueryBuilder<ContactDatabase>(ContactDatabase())
        ..whereEqualTo(ContactDatabase.roCode, roCode)..whereEqualTo(
            ContactDatabase.contactType, contactType);
    }
    if (textSearch == "") {

    } else {
      queryBuilder = queryBuilder..whereContains(
            ContactDatabase.contactName, textSearch);
    }
    return queryBuilder.query();
  }
}
