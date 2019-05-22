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

  set ledger_description(String ledger_description) => set<String>(ledgerDescription, ledger_description);


  static const String keyPlus = 'plus';

  num get plus => get<num>(keyPlus);

  set plus(num plus) => super.set<num>(keyPlus, plus);

  static const String keyMinus = 'minus';

  num get minus => get<num>(keyMinus);

  set minus(num minus) => super.set<num>(keyMinus, minus);

  LedgerDatabase makeEntry(String roCode,String ledgerID,String desc,num plus,num minus){
    LedgerDatabase ledgerDatabase = new LedgerDatabase();
    ledgerDatabase.ro_code = roCode;
    ledgerDatabase.ledger_id=ledgerID;
    ledgerDatabase.ledger_description=desc;
    ledgerDatabase.plus=plus;
    ledgerDatabase.minus=minus;
    return ledgerDatabase;
  }
}
