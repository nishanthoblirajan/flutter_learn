
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/DataClasses/LedgerDatabase.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedgerView extends StatefulWidget {
  String ledgerID;
  @override
  _LedgerViewState createState() => _LedgerViewState();

  LedgerView({Key key, @required this.ledgerID}):super(key:key);
}

class _LedgerViewState extends State<LedgerView> {
  String ledgerName = '';
  String ledgerID = '';

  @override
  initState() {
    initSharedPrefs();
    ledgerID = widget.ledgerID;
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
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            print('Im Inside');
            return ListView(children: _getData(snapshot));
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
      future:
      _query(roCode, ledgerID),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(ledgerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              Expanded(child: futurebuilder),
            ],
          ),
        ),
      ),
    );
  }
  _query(String roCode, String ledgerID) async {
    QueryBuilder<ParseObject> queryBuilder;
      queryBuilder = QueryBuilder<LedgerDatabase>(LedgerDatabase())
        ..whereEqualTo(LedgerDatabase.roCode, roCode)..whereEqualTo(LedgerDatabase.ledgerID, ledgerID);
    return queryBuilder.query();
  }
  List<LedgerDatabase> _ledgerDatabase = [];

  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _ledgerDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        LedgerDatabase ledgerDatabase =
        new LedgerDatabase().fromJson(output);
        print('ledger description : ${ledgerDatabase.ledger_description}');
        _ledgerDatabase.add(ledgerDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _ledgerDatabase.length; index++) {
      widgetLists.add(ListTile(
        title: Text(_ledgerDatabase[index].ledger_description),
        trailing: Text('${_ledgerDatabase[index].plus}'),
      ));
    }
    return widgetLists;
  }
}
