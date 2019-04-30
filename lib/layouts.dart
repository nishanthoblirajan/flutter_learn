import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context) => Drawer(
  child: ListView(
    children: <Widget>[
      buildHeadingMenu(context,'Menu'),
      buildMenuItem(context,'Dashboard','myapp'),
      buildMenuItem(context,'Product','productscreen'),
      buildHeadingMenu(context,'Sale'),
//            buildMenuItem('Invoice'),
//            buildMenuItem('Payment'),
//            buildHeadingMenu('Purchase'),
//            buildMenuItem('Invoice'),
//            buildMenuItem('Payment'),
//            buildHeadingMenu('Expenses'),
//            buildMenuItem('New Expense'),
//            buildHeadingMenu('Service'),
//            buildMenuItem('Repair'),
//            buildHeadingMenu('Others'),
//            buildMenuItem('Banking'),
//            buildHeadingMenu('Admin'),
//            buildMenuItem('Report'),
//            buildMenuItem('Staff List'),
//            buildMenuItem('Change Password'),
//            buildMenuItem('Settings'),
//            buildMenuItem('Logout')
    ],
  ),
);

/*TODO build menu dynamically using List<String> as the function argument*/
Widget buildMenuItem(BuildContext context,String name,String route) {
  return Container(
    child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(name),
        onTap: () {

          Navigator.pushNamed(context, '/'+route);
          /*TODO flutter toast not showing check the flutter package*/
//          Fluttertoast.showToast(msg: "Hello");
        }
    ),
  );
}

Widget buildHeadingMenu(BuildContext context,String name) {
  return Container(
    child: ListTile(
      title: Text(
        name,
        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
      ),
    ),
  );
}