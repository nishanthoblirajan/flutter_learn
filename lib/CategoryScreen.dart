import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataClasses/CategoryDatabase.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String loadingScreen = 'Loading...';


  TextEditingController searchTextController = new TextEditingController();
  @override
  initState() {
    searchTextController.text="";
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
        title: new Text('Category'),
      ),
      body: Padding(padding: const EdgeInsets.all(12.0),
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
                child: new FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text(loadingScreen),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return new ListTile(
                            title: Text(_categoryDatabase[index].category_name),
                            subtitle: Text(
                                _categoryDatabase[index].category_type),
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    }
                  },
                  future: query(roCode,searchTextController.text),
                )),
          ],
        ),
      ),),
    );
  }

  List<CategoryDatabase> _categoryDatabase = [];
  query(String roCode,String textSearch) async {
    QueryBuilder<ParseObject> queryBuilder;
    if(textSearch==""){
      queryBuilder =
      QueryBuilder<CategoryDatabase>(CategoryDatabase())
        ..whereEqualTo(CategoryDatabase.roCode, roCode);
    }else{
      queryBuilder =
      QueryBuilder<CategoryDatabase>(CategoryDatabase())
        ..whereEqualTo(CategoryDatabase.roCode, roCode)..whereEqualTo(CategoryDatabase.categoryName, textSearch);
    }

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      setState(() {
        _categoryDatabase = new List();

      });
      for (int i = 0; i < listFromApi.length; i++) {
        print(listFromApi[i].toString());
        Map output = json.decode(listFromApi[i].toString());
        CategoryDatabase categoryDatabase =
        new CategoryDatabase().fromJson(output);
        print(categoryDatabase.category_name);
        setState(() {
          _categoryDatabase.add(categoryDatabase);
        });
      }
      return _categoryDatabase;
    } else {
      setState(() {
        loadingScreen = "No data found";
      });
      print('Result: ${apiResponse.error.message}');
    }
  }


}
