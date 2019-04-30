import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Testing",
      home: new Scaffold(
        appBar: AppBar(
          title: Text('LSSM'),
        ),
        body: buildContainer(),
        drawer: buildDrawer(),
      ),
    );
  }

  Drawer buildDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            buildHeadingMenu('Menu'),
            buildMenuItem('Dashboard'),
            buildMenuItem('Product'),
            buildHeadingMenu('Sale'),
            buildMenuItem('Invoice'),
            buildMenuItem('Payment'),
            buildHeadingMenu('Purchase'),
            buildMenuItem('Invoice'),
            buildMenuItem('Payment'),
            buildHeadingMenu('Expenses'),
            buildMenuItem('New Expense'),
            buildHeadingMenu('Service'),
            buildMenuItem('Repair'),
            buildHeadingMenu('Others'),
            buildMenuItem('Banking'),
            buildHeadingMenu('Admin'),
            buildMenuItem('Report'),
            buildMenuItem('Staff List'),
            buildMenuItem('Change Password'),
            buildMenuItem('Settings'),
            buildMenuItem('Logout')
          ],
        ),
      );

  /*TODO build menu dynamically using List<String> as the function argument*/
  Widget buildMenuItem(String name) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(name),
        onTap: () {
          /*TODO flutter toast not showing check the flutter package*/
          Fluttertoast.showToast(msg: "Hello");},
      ),
    );
  }

  Widget buildHeadingMenu(String name) {
    return Container(
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Colors.blueGrey, fontSize: 12),
        ),
      ),
    );
  }

  Widget buildContainer() {
    return new Container(
      child: Text('Dashboard'),
    );
  }
}
