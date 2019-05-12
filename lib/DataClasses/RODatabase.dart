
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RODatabase extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'RODatabase';

  RODatabase() : super(_keyTableName);

  RODatabase.clone() : this();

  @override
  clone(Map map) => RODatabase.clone()..fromJson(map);

  static const String roCode = 'ro_code';

  String get ro_code => get<String>(roCode);

  set ro_code(String ro_code) => set<String>(roCode, ro_code);

  static const String invoiceNumber = 'invoice_number';

  String get invoice_number => get<String>(invoiceNumber);

  set invoice_number(String invoice_number) =>
      set<String>(invoiceNumber, invoice_number);

  static const String purchaseNumber = 'purchase_number';

  String get purchase_number => get<String>(purchaseNumber);

  set purchase_number(String purchase_number) =>
      set<String>(purchaseNumber, purchase_number);


}
