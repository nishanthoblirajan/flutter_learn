
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

  static const String productID = 'product_id';
  String get product_id => get<String>(productID);
  set product_id(String product_id) => set<String>(productID, product_id);

  static const String productQuantity = 'product_quantity';
  String get product_quantity => get<String>(productQuantity);
  set product_quantity(String product_quantity) => set<String>(productQuantity, product_quantity);


}


