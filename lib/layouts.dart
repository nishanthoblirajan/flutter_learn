import 'package:flutter/material.dart';

import 'AddContactScreen.dart';
import 'AdminContactsScreen.dart';
import 'CategoryScreen.dart';
import 'ContactScreen.dart';
import 'DataClasses/ContactDatabase.dart';

Widget buildDrawer(BuildContext context) => Drawer(
      child: ListView(
        children: <Widget>[
          buildHeadingMenu('Menu'),
          buildMenuItem(context, 'Dashboard', 'myapp'),
          buildMenuItem(context, 'POS', 'pos'),
          buildMenuItem(context, 'Product', 'productscreen'),
          buildHeadingMenu('Sale'),
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text('Customers'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => ContactScreen(
                        contactType: 'Customer',
                        isAdmin: true,
                      )));
                }),
          ),
          buildMenuItem(context, 'Invoice', 'invoicescreen'),
          buildMenuItemWithout('Payment'),
          buildHeadingMenu('Purchase'),
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text('Vendor'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => ContactScreen(
                        contactType: 'Vendor',
                        isAdmin: true,
                      )));
                }),
          ),
          buildMenuItemWithout('Invoice'),
          buildMenuItemWithout('Payment'),
          buildHeadingMenu('Expenses'),
          buildMenuItemWithout('New Expense'),
          buildHeadingMenu('Service'),
          buildMenuItemWithout('Repair'),
          buildHeadingMenu('Others'),
          buildMenuItemWithout('Banking'),
          buildHeadingMenu('Admin'),
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text('Category'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                            categoryType: 'Product',
                            isAdmin: true,
                          )));
                }),
          ),
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text('Contacts'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AdminContactsScreen(
                        isAdmin: true,
                      )));
                }),
          ),
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
        }),
  );
}

Widget buildMenuItemWithout(String name) {
  return Container(
    child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(name),
        onTap: () {}),
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
