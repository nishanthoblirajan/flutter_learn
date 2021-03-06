
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/AddCategoryScreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataClasses/CategoryDatabase.dart';

class CategoryScreen extends StatefulWidget {
  String categoryType;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();

  CategoryScreen({Key key, @required this.categoryType}) : super(key: key);
}

class _CategoryScreenState extends State<CategoryScreen> {
  String loadingScreen = 'Loading...';

  String categoryType;

  TextEditingController searchTextController = new TextEditingController();

  @override
  initState() {
    categoryType = widget.categoryType;
    searchTextController.text = "";
    initSharedPrefs();
    query(roCode, categoryType, searchTextController.text);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /*TODO add new category name*/
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => AddCategoryScreen(
                categoryType: 'Product',
                categoryList: _categoryDatabase,
              )));
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
      appBar: AppBar(
        title: new Text(categoryType + ' Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: new Column(
            children: <Widget>[
              Expanded(
                  child: new FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return new ListTile(
                              title: Text(_categoryDatabase[index].category_name),
                              onTap: () {
                                sharedPreferences.setString(
                                    categoryType + "_category",
                                    _categoryDatabase[index].category_name);
                                Navigator.of(context).pop({
                                  'category_selection':
                                  _categoryDatabase[index].category_name
                                });
                              },
                            );
                          },
                          itemCount: snapshot.data.length,
                        );
                      }
                    },
                    future: query(roCode, categoryType, searchTextController.text),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryDatabase> _categoryDatabase = [];

  query(String roCode, String categoryType, String textSearch) async {
    QueryBuilder<ParseObject> queryBuilder;
    if (textSearch == "") {
      queryBuilder = QueryBuilder<CategoryDatabase>(CategoryDatabase())
        ..whereEqualTo(CategoryDatabase.roCode, roCode)
        ..whereEqualTo(CategoryDatabase.categoryType, categoryType);
    } else {
      queryBuilder = QueryBuilder<CategoryDatabase>(CategoryDatabase())
        ..whereEqualTo(CategoryDatabase.roCode, roCode)
        ..whereEqualTo(CategoryDatabase.categoryType, categoryType)
        ..whereEqualTo(CategoryDatabase.categoryName, textSearch);
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
    } else if(apiResponse.result==null){
      setState(() {
//        loadingScreen = "No data found";
      });
      print('Result: ${apiResponse.error.message}');
    }
  }
}
