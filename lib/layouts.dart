import 'package:flutter/material.dart';

Widget buildDrawer(BuildContext context) => Drawer(
      child: ListView(
        children: <Widget>[
          buildHeadingMenu('Menu'),
          buildMenuItem(context, 'Dashboard', 'myapp'),
          buildMenuItem(context, 'Product', 'productscreen'),
          buildHeadingMenu('Sale'),
          buildMenuItem(context,'Invoice','saleinvoice'),
          buildMenuItemWithout('Payment'),
          buildHeadingMenu('Purchase'),
          buildMenuItemWithout('Invoice'),
          buildMenuItemWithout('Payment'),
          buildHeadingMenu('Expenses'),
          buildMenuItemWithout('New Expense'),
          buildHeadingMenu('Service'),
          buildMenuItemWithout('Repair'),
          buildHeadingMenu('Others'),
          buildMenuItemWithout('Banking'),
          buildHeadingMenu('Admin'),
          buildMenuItemWithout('Report'),
          buildMenuItemWithout('Staff List'),
          buildMenuItemWithout('Change Password'),
          buildMenuItemWithout('Settings'),
          buildMenuItemWithout('Logout')
        ],
      ),
    );

/*TODO build menu dynamically using List<String> as the function argument*/
Widget buildMenuItem(BuildContext context, String name, String route) {
  return Container(
    child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(name),
        onTap: () {
          Navigator.pushNamed(context, '/' + route);
          /*TODO flutter toast not showing check the flutter package*/
//          Fluttertoast.showToast(msg: "Hello");
        }),
  );
}

Widget buildMenuItemWithout(String name) {
  return Container(
    child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(name),
        onTap: () {
//          Navigator.pushNamed(context, '/'+route);
          /*TODO flutter toast not showing check the flutter package*/
//          Fluttertoast.showToast(msg: "Hello");
        }),
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
