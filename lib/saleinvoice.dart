import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class saleinvoice extends StatefulWidget {
  @override
  _saleinvoiceState createState() => _saleinvoiceState();
}

class _saleinvoiceState extends State<saleinvoice> {
  @override
  initState() {
    initSharedPrefs();
    super.initState();
  }

  SharedPreferences sharedPreferences;
  String roCode;

  initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      roCode = sharedPreferences.getString('ro_code');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
