import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/productscreen.dart';
import 'package:hello_world/layouts.dart';
import 'package:hello_world/addproductscreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'ApplicationConstants.dart';
import 'CategoryScreen.dart';
import 'saleinvoice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(
      title: "Flutter testing",
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      routes: <String, WidgetBuilder>{
        '/myapp': (context) => MyApp(),
        '/productscreen': (context) => productscreen(),
        '/addproductscreen': (context) => addproductscreen(),
        '/saleinvoice': (context) => saleinvoice(),
        '/categoryscreen':(context)=>CategoryScreen()
      },
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String databaseConnectionStatus = "";
  SharedPreferences sharedPreferences;
  String roCode;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('LSSM'),
      ),
      body: buildContainer(),
      drawer: buildDrawer(context),
    );
  }

  @override
  initState() {
    initParse();
    _setSharedPreference();
    super.initState();
  }

  initParse() async {
    Parse().initialize(ApplicationConstants.keyParseApplicationId,
        ApplicationConstants.keyParseServerUrl,
        masterKey: ApplicationConstants.keyParseMasterKey,
        clientKey: ApplicationConstants.keyParseCustomerKey,
        debug: true);
    var response = await Parse().healthCheck();
    if (response.success) {
        print("Success");
    } else {
        print("Server health check failed");
    }
  }

  Widget buildContainer() {
    return new Container(
      child: Text(databaseConnectionStatus + ' ----> RO Code ' + roCode),
    );
  }

  _setSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('ro_code', '12345');
    setState(() {
      roCode = sharedPreferences.getString('ro_code');
    });
  }
}
