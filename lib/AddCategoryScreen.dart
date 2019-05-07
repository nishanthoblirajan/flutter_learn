import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataClasses/CategoryDatabase.dart';

class AddCategoryScreen extends StatefulWidget {
  String categoryType;

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();

  AddCategoryScreen({Key key, @required this.categoryType}) : super(key: key);
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  String categoryType;
  TextEditingController categoryNameController;

  @override
  void initState() {
    // TODO: implement initState
    categoryType = widget.categoryType;
    categoryNameController = new TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: new Text('Add ' + categoryType + ' Category'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: categoryNameController,
                decoration: InputDecoration(labelText: 'Category Name'),
                textInputAction: TextInputAction.next,
              ),
            ),
            RaisedButton(
              onPressed: () {
                addCategory(roCode, categoryType, categoryNameController.text);
              },
              child: Text('Add Category'),
            )
          ],
        ),
      ),
    );
  }

  Future addCategory(
      String roCode, String categoryType, String categoryName) async {
    print('Add Category'+roCode+" "+categoryType+" "+categoryName);
    CategoryDatabase categoryDatabase = new CategoryDatabase();
    categoryDatabase.ro_code = roCode;
    categoryDatabase.category_type = categoryType;
    categoryDatabase.category_name = categoryName;
    var saveResponse = await categoryDatabase.save();
    if (saveResponse.success) {
      Fluttertoast.showToast(
          msg: 'Category Saved', backgroundColor: Colors.blue);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
    }
  }
}
