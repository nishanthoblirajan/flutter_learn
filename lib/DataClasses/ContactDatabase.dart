
import 'package:parse_server_sdk/parse_server_sdk.dart';

class ContactDatabase extends ParseObject implements ParseCloneable {
  ContactDatabase() : super(_keyTableName);

  ContactDatabase.clone() : this();

  @override clone(Map map) =>
      ContactDatabase.clone()
        ..fromJson(map);
  static const String _keyTableName = 'ContactDatabase';

  static const String roCode = 'ro_code';
  String get ro_code => get<String>(roCode);
  set ro_code(String ro_code) => set<String>(roCode, ro_code);


  static const String contactName = 'contact_name';
  String get contact_name => get<String>(contactName);
  set contact_name(String contact_name) => set<String>(contactName, contact_name);


  static const String contactAddress = 'contact_address';
  String get contact_address => get<String>(contactAddress);
  set contact_address(String contact_address) => set<String>(contactAddress, contact_address);

  static const String contactPhoneNumber = 'contact_phone';
  String get contact_phone => get<String>(contactPhoneNumber);
  set contact_phone(String contact_phone) => set<String>(contactPhoneNumber, contact_phone);

  static const String contactGST = 'contact_gst';
  String get contact_gst => get<String>(contactGST);
  set contact_gst(String contact_gst) => set<String>(contactGST, contact_gst);

  static const String contactBusiness = 'contact_business';
  String get contact_business => get<String>(contactBusiness);
  set contact_business(String contact_business) => set<String>(contactBusiness, contact_business);

  /* Contact Type - Customer / Vendor */
  static const String contactType = 'contact_type';
  String get contact_type => get<String>(contactType);
  set contact_type(String contact_type) => set<String>(contactType, contact_type);










}


