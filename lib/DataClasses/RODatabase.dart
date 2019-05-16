
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

  static const String keyInvoiceNumber='invoice_number';


  num get invoice_number => get<num>(keyInvoiceNumber);
  set invoice_number(num invoiceNumber) => super.set<num>(keyInvoiceNumber, invoiceNumber);


  static const String purchaseNumber = 'purchase_number';

  num get purchase_number => get<num>(purchaseNumber);

  set purchase_number(num purchase_number) =>
      set<num>(purchaseNumber, purchase_number);


}
