
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

  //TODO add invoice Type



  static const String invoiceNumber = 'invoice_number';
  String get invoice_number => get<String>(invoiceNumber);
  set invoice_number(String invoice_number) => set<String>(invoiceNumber, invoice_number);

  static const String invoiceDate = 'invoice_date';
  String get invoice_date => get<String>(invoiceDate);
  set invoice_date(String invoice_date) => set<String>(invoiceDate, invoice_date);


  static const String contactID = 'contact_id';
  String get contact_id => get<String>(contactID);
  set contact_id(String contact_id) => set<String>(contactID, contact_id);

  //TODO Error: schema mismatch for InvoiceDatabase.product_id; expected String but got Array
  static const String productID = 'product_id';
  List<String> get product_id => get<List<String>>(productID);
  set product_id(List<String> product_id) => set<List<String>>(productID, product_id);

  static const String productQuantity = 'product_quantity';
  String get product_quantity => get<String>(productQuantity);
  set product_quantity(String product_quantity) => set<String>(productQuantity, product_quantity);

  static const String productPriceTotal = 'product_price_total';
  String get product_price_total => get<String>(productPriceTotal);
  set product_price_total(String product_price_total) => set<String>(productPriceTotal, product_price_total);




}


