import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/DataClasses/ContactDatabase.dart';
import 'package:hello_world/DataClasses/LedgerDatabase.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedgerView extends StatefulWidget {
  String ledgerID;

  @override
  _LedgerViewState createState() => _LedgerViewState();

  LedgerView({Key key, @required this.ledgerID}) : super(key: key);
}

class _LedgerViewState extends State<LedgerView> {
  ContactDatabase contactDatabase;
  String ledgerID = '';
  String ledgerName = '';

  @override
  initState() {
    initSharedPrefs();
    ledgerID = widget.ledgerID;
    getContactFromID(ledgerID);
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
            return _getData(snapshot);
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
      future: _query(roCode, ledgerID),
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

  void buildAppBarTitle() {
    if (contactDatabase != null) {
      setState(() {
        ledgerName = 'Ledger - ${contactDatabase.contact_name}';
      });
    } else {
      setState(() {
        ledgerName = '';
      });
    }
  }

  _query(String roCode, String ledgerID) async {
    QueryBuilder<ParseObject> queryBuilder;
    queryBuilder = QueryBuilder<LedgerDatabase>(LedgerDatabase())
      ..whereEqualTo(LedgerDatabase.roCode, roCode)
      ..whereEqualTo(LedgerDatabase.ledgerID, ledgerID);
    return queryBuilder.query();
  }

  List<LedgerDatabase> _ledgerDatabase = [];

  Widget _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _ledgerDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        LedgerDatabase ledgerDatabase = new LedgerDatabase().fromJson(output);
        print('ledger description : ${ledgerDatabase.ledger_description}');
        _ledgerDatabase.add(ledgerDatabase);
      }
    }

    num ledgerBalance = 0;
    //Remove all the zeros
    for(int i=0;i<_ledgerDatabase.length;i++){
        ledgerBalance =ledgerBalance+_ledgerDatabase[i].plus-_ledgerDatabase[i].minus;
    }

    //Working now
    return Column(
      children: <Widget>[
        Text('Ledger Balance is $ledgerBalance'),
        DataTable(
            columns: <DataColumn>[
              DataColumn(
                  label: Expanded(
                    child: Container(child: Text('Description')),
                    flex: 2,
                  )),
              DataColumn(
                  label: Expanded(
                      child: Container(child: Text('Plus')), flex: 1)),
//              DataColumn(label: Text('Tax')),
              DataColumn(
                  label: Expanded(
                    child: Container(child: Text('Minus')),
                    flex: 1,
                  )),
            ],
            /*TODO error
                  * Another exception was thrown: RangeError (index): Invalid value: Not in range 0..2, inclusive: 3*/
            rows: List.generate(_ledgerDatabase.length, (index) {
              return DataRow(cells: <DataCell>[
                DataCell(Text(_ledgerDatabase[index].ledger_description)),
                DataCell(Text('${_ledgerDatabase[index].plus}')),
                DataCell(Text('${_ledgerDatabase[index].minus}')),
              ]);
            })),
      ],
    );

  }

  Future<void> getContactFromID(String objectID) async {
    ParseResponse apiResponse = await ContactDatabase().getObject(objectID);

    if (apiResponse.success && apiResponse.count > 0) {
      setState(() {
        contactDatabase = apiResponse.result;
        print('ledgerName $contactDatabase');
      });
      buildAppBarTitle();
      return contactDatabase;
    } else {
      print(keyAppName + ': ' + apiResponse.error.message);
      return '';
    }
  }
}
