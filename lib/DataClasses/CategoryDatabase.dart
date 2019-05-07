

import 'package:parse_server_sdk/parse_server_sdk.dart';

class CategoryDatabase extends ParseObject implements ParseCloneable{
  CategoryDatabase() : super(_keyTableName);
  CategoryDatabase.clone(): this();
  static const String _keyTableName = 'CategoryDatabase';

  @override clone(Map map) => CategoryDatabase.clone()..fromJson(map);

  static const String roCode = 'ro_code';
  String get ro_code => get<String>(roCode);
  set ro_code(String ro_code) => set<String>(roCode, ro_code);

  static const String categoryName = 'category_name';
  String get category_name => get<String>(categoryName);
  set category_name(String category_name) => set<String>(categoryName, category_name);


  static const String categoryType = 'category_type';
  String get category_type => get<String>(categoryType);
  set category_type(String category_type) => set<String>(categoryType, category_type);

}