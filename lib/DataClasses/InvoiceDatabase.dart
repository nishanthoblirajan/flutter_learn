
import 'package:parse_server_sdk/parse_server_sdk.dart';

class InvoiceDatabase extends ParseObject implements ParseCloneable {
  InvoiceDatabase() : super(_keyTableName);

  InvoiceDatabase.clone() : this();

  @override clone(Map map) =>
      InvoiceDatabase.clone()
        ..fromJson(map);
  static const String _keyTableName = 'InvoiceDatabase';

  static const String roCode = 'ro_code';
  String get ro_code => get<String>(roCode);
  set ro_code(String ro_code) => set<String>(roCode, ro_code);








}


