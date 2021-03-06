import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/AddCategoryScreen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataClasses/CategoryDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';



class CategoryScreen extends StatefulWidget {
  String categoryType;

  bool isAdmin;
  @override
  _CategoryScreenState createState() => _CategoryScreenState();

  CategoryScreen({Key key, @required this.categoryType, this.isAdmin}) : super(key: key);
}

class _CategoryScreenState extends State<CategoryScreen> {
  String categoryType;

  bool isAdmin;

  TextEditingController searchTextController = new TextEditingController();

  Widget _appBarTitle;
  Icon _searchIcon = new Icon(Icons.search);

  /*Use normal listview after setting the query in initState*/
  @override
  initState() {
    isAdmin = widget.isAdmin;
    categoryType = widget.categoryType;
    searchTextController.text = "";
    _appBarTitle = new Text(categoryType + ' Category');

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
    void _searchPressed() {
      setState(() {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            controller: searchTextController,
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',
            ),
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text(categoryType + ' Category');
        }
      });
    }


    var futurebuilder = new FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('Connection State: ' + snapshot.connectionState.toString());
        if(snapshot.hasData){
          if(snapshot.data!=null){
            print('Im Inside');
            return ListView(children:
            _getData(snapshot));
          }else{
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        }else{
          return Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
      future: _query(roCode, categoryType, searchTextController.text),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          /*TODO add new category name*/
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
                  AddCategoryScreen(
                    categoryType: 'Product',
                    categoryList: _categoryDatabase,
                  )));
        },
        icon: Icon(Icons.add),
        label: Text('Add'),
      ),
        appBar: AppBar(
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
                icon: _searchIcon,
                onPressed: () {
                  _searchPressed();
                })
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: new Column(
            children: <Widget>[
              Expanded(child: futurebuilder),
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryDatabase> _categoryDatabase = [];



  List<Widget> _getData(AsyncSnapshot snapshot) {
    ParseResponse apiResponse = snapshot.data;
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      _categoryDatabase = new List();
      for (int i = 0; i < listFromApi.length; i++) {
        Map output = json.decode(listFromApi[i].toString());
        CategoryDatabase categoryDatabase =
        new CategoryDatabase().fromJson(output);
        print(categoryDatabase.category_name);
        _categoryDatabase.add(categoryDatabase);
      }
    }

    List<Widget> widgetLists = new List();
    for (int index = 0; index < _categoryDatabase.length; index++) {
      widgetLists.add(ListTile(
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if(isAdmin){
                deleteCategoryFromDatabase(_categoryDatabase[index]);
            }else{
              Fluttertoast.showToast(msg: 'Require Admin');
            }

          },
        ),
        title: Text(_categoryDatabase[index].category_name),
        onTap: () {
          sharedPreferences.setString(categoryType + "_category",
              _categoryDatabase[index].category_name);
          Navigator.of(context).pop({
            'category_selection':
            _categoryDatabase[index].category_name
          });
        },
      ));
    }
    return widgetLists;
  }

}

/*TODO 09/05/2019 implement category screen search*/
_query(String roCode, String categoryType, String textSearch) async {
  QueryBuilder<ParseObject> queryBuilder;
  if (textSearch == "") {
    queryBuilder = QueryBuilder<CategoryDatabase>(CategoryDatabase())
      ..whereEqualTo(CategoryDatabase.roCode, roCode)..whereEqualTo(
          CategoryDatabase.categoryType, categoryType);
  } else {
    queryBuilder = QueryBuilder<CategoryDatabase>(CategoryDatabase())
      ..whereEqualTo(CategoryDatabase.roCode, roCode)..whereEqualTo(
          CategoryDatabase.categoryType, categoryType)..whereContains(
          CategoryDatabase.categoryName, textSearch);
  }
  return queryBuilder.query();
}

/*Delete*/
Future deleteCategoryFromDatabase(
    CategoryDatabase receivedCategoryDatabase) async {
  String objectID = receivedCategoryDatabase.get('objectId');
  print('Delete ' + objectID);
  CategoryDatabase categoryDatabase = new CategoryDatabase();
  categoryDatabase.set('objectId', objectID);
  print('Delete ' + categoryDatabase.toString());
  var deleteResponse = await categoryDatabase.delete();
  if (deleteResponse.success) {
    Fluttertoast.showToast(
        msg: 'Product Deleted', backgroundColor: Colors.blue);
  } else {
    Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
  }
}
