import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class LedgerDatabase extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'LedgerDatabase';

  LedgerDatabase() : super(_keyTableName);

  LedgerDatabase.clone() : this();

  @override
  clone(Map map) => LedgerDatabase.clone()..fromJson(map);

  static const String roCode = 'ro_code';

  String get ro_code => get<String>(roCode);

  set ro_code(String ro_code) => set<String>(roCode, ro_code);

  static const String ledgerID = 'ledger_id';

  String get ledger_id => get<String>(ledgerID);

  set ledger_id(String ledger_id) => set<String>(ledgerID, ledger_id);

  static const String ledgerDescription = 'ledger_description';

  String get ledger_description => get<String>(ledgerDescription);

  set ledger_description(String ledger_description) =>
      set<String>(ledgerDescription, ledger_description);

  static const String keyPlus = 'plus';

  num get plus => get<num>(keyPlus);

  set plus(num plus) => super.set<num>(keyPlus, plus);

  static const String keyMinus = 'minus';

  num get minus => get<num>(keyMinus);

  set minus(num minus) => super.set<num>(keyMinus, minus);

  Future<bool> makeEntry(
      String roCode, String ledgerID, String desc, num plus, num minus) async {
    LedgerDatabase ledgerDatabase = new LedgerDatabase();
    ledgerDatabase.ro_code = roCode;
    ledgerDatabase.ledger_id = ledgerID;
    ledgerDatabase.ledger_description = desc;
    ledgerDatabase.plus = plus;
    ledgerDatabase.minus = minus;
    ParseResponse response = await ledgerDatabase.save();
    if (response.success) {
      print('ledger saves successfully for desc $desc');
      return true;
    } else {
      return false;
    }
  }

  Widget buildData(List<LedgerDatabase> _ledgerDatabase) {
    if(_ledgerDatabase!=null) {
      print('ledgerDatabase is ${_ledgerDatabase.length}');
      return new Container(
        child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                  label: Expanded(
                    child: Container(child: Text('Date')),
                    flex: 2,
                  )),
              DataColumn(
                  label: Expanded(
                      child: Container(child: Text('Description')),
                      flex: 1)),
              DataColumn(
                  label: Expanded(
                    child: Container(child: Text('Plus')),
                    flex: 1,
                  )),
              DataColumn(
                  label: Expanded(
                    child: Container(child: Text('Minus')),
                    flex: 3,
                  )),
            ],
            rows: List.generate(_ledgerDatabase.length, (index) {
              return DataRow(cells: <DataCell>[
                DataCell(Text('${_ledgerDatabase[index].createdAt
                    .day}/${_ledgerDatabase[index].createdAt
                    .month}/${_ledgerDatabase[index].createdAt.year}')),
                DataCell(Text(
                    '${_ledgerDatabase[index].ledger_description}')),
                DataCell(
                    Text(_ledgerDatabase[index].plus.toString())),
                DataCell(Text(
                    _ledgerDatabase[index].minus.toString())),
              ]);
            })),
      );
    }else{
      return new Container(
        child: Text('No Payments'),
      );
    }
  }

  Future<List<LedgerDatabase>> checkEntry(String roCode, String ledgerID, String desc) async {
    QueryBuilder<ParseObject> queryBuilder;
    queryBuilder = QueryBuilder<LedgerDatabase>(LedgerDatabase())
      ..whereEqualTo(LedgerDatabase.roCode, roCode)
      ..whereEqualTo(LedgerDatabase.ledgerID, ledgerID)
      ..whereContains(LedgerDatabase.ledgerDescription, desc);
    List<LedgerDatabase> _ledgerDatabase = new List();
    ParseResponse apiResponse = await queryBuilder.query();
    if(apiResponse.success){
      final List<ParseObject> listFromApi = apiResponse.result;
        for (int i = 0; i < listFromApi.length; i++) {
          Map output = json.decode(listFromApi[i].toString());
          LedgerDatabase ledgerDatabase =
          new LedgerDatabase().fromJson(output);

          print('To String of the invoice ' + ledgerDatabase.toString());
          _ledgerDatabase.add(ledgerDatabase);
        }
    }
    return _ledgerDatabase;
  }

}
