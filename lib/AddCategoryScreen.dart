import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataClasses/CategoryDatabase.dart';

class AddCategoryScreen extends StatefulWidget {
  String categoryType;
  List<CategoryDatabase> categoryList;

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();

  AddCategoryScreen({Key key, @required this.categoryType,@required this.categoryList}) : super(key: key);
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
   String categoryType;
  List<CategoryDatabase> categoryList;

  TextEditingController categoryNameController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    categoryType = widget.categoryType;
    categoryList = widget.categoryList;
    categoryNameController.text="";
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
    var found = false;
    for(int i=0;i<categoryList.length;i++){
      if(categoryList[i].category_name==categoryName){
        found = true;
        Fluttertoast.showToast(msg: 'Category already present');
      }
    }
    if(!found){
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


}
