
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



  static const String keyInvoiceNumber = 'invoice_number';

  num get invoice_number => get<num>(keyInvoiceNumber);
  set invoice_number(num invoice_number) => set<num>(keyInvoiceNumber, invoice_number);

  static const String invoiceDate = 'invoice_date';
  String get invoice_date => get<String>(invoiceDate);
  set invoice_date(String invoice_date) => set<String>(invoiceDate, invoice_date);


  static const String contactID = 'contact_id';
  String get contact_id => get<String>(contactID);
  set contact_id(String contact_id) => set<String>(contactID, contact_id);

  static const String productID = 'product_id';
  String get product_id => get<String>(productID);
  set product_id(String product_id) => set<String>(productID, product_id);


  static const String productName = 'product_name';
  String get product_name => get<String>(productName);
  set product_name(String product_name) => set<String>(productName, product_name);


  static const String productQuantity = 'product_quantity';
  String get product_quantity => get<String>(productQuantity);
  set product_quantity(String product_quantity) => set<String>(productQuantity, product_quantity);

  static const String productPriceMRP = 'product_price_MRP';
  String get product_price_MRP => get<String>(productPriceMRP);
  set product_price_MRP(String product_price_MRP) => set<String>(productPriceMRP, product_price_MRP);


  static const String productPriceTotal = 'product_price_total';
  String get product_price_total => get<String>(productPriceTotal);
  set product_price_total(String product_price_total) => set<String>(productPriceTotal, product_price_total);



  /*Remember: ProductPriceTotal gets the total for each product
  * InvoicePriceTotal gets the total for each Invoice*/
  static const String invoicePriceTotal = 'invoice_price_total';
  String get invoice_price_total => get<String>(invoicePriceTotal);
  set invoice_price_total(String invoice_price_total) => set<String>(invoicePriceTotal, invoice_price_total);




}


