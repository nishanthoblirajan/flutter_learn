import 'package:parse_server_sdk/parse_server_sdk.dart';

class ProductDatabase extends ParseObject implements ParseCloneable{

  ProductDatabase() : super(_keyTableName);
  ProductDatabase.clone(): this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override clone(Map map) => ProductDatabase.clone()..fromJson(map);

  static const String _keyTableName = 'ProductDatabase';

  static const String roCode = 'ro_code';
  String get ro_code => get<String>(roCode);
  set ro_code(String ro_code) => set<String>(roCode, ro_code);

  static const String keyName = 'product_name';
  String get name => get<String>(keyName);
  set name(String name) => set<String>(keyName, name);

  static const String keySKU = 'product_sku';
  String get sku => get<String>(keySKU);
  set sku(String sku) => set<String>(keySKU, sku);

  static const String keySalePrice = 'product_sale_price';
  String get salePrice => get<String>(keySalePrice);
  set salePrice(String salePrice) => set<String>(keySalePrice, salePrice);

  static const String keyPurchasePrice = 'product_purchase_price';
  String get purchasePrice => get<String>(keyPurchasePrice);
  set purchasePrice(String purchasePrice) => set<String>(keyPurchasePrice, purchasePrice);

  static const String keyQuantity = 'product_quantity';
  String get quantity => get<String>(keyQuantity);
  set quantity(String quantity) => set<String>(keyQuantity, quantity);

  static const String keyTaxCode = 'tax_code';
  String get taxCode => get<String>(keyTaxCode);
  set taxCode(String taxCode) => set<String>(keyTaxCode, taxCode);

  static const String keyTaxName = 'tax_name';
  String get taxName => get<String>(keyTaxName);
  set taxName(String taxName) => set<String>(keyTaxName, taxName);

  static const String keySgst = 'sgst';
  String get sgst => get<String>(keySgst);
  set sgst(String sgst) => set<String>(keySgst, sgst);

  static const String keyCgst = 'cgst';
  String get cgst => get<String>(keyCgst);
  set cgst(String cgst) => set<String>(keyCgst, cgst);

  static const String keyCategoryName = 'category_name';
  String get categoryName => get<String>(keyCategoryName);
  set categoryName(String categoryName) => set<String>(keyCategoryName, categoryName);




}