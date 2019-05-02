import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/layouts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ApplicationConstants.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class productscreen extends StatefulWidget {
  @override
  _productscreenState createState() => _productscreenState();
}

/*TODO show all the products added below the Add New Products Button*/

class _productscreenState extends State<productscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Add New Product');
                  Navigator.pushNamed(context, '/addproductscreen');
                },
                child: Text('Add New Product'),
              ),
              Expanded(child:
              new FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return new ListTile(
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  }
                },
                future: query(),
              ),),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState(){
    initParse();
    super.initState();
  }

  initParse() async {
    Parse().initialize(ApplicationConstants.keyParseApplicationId,
        ApplicationConstants.keyParseServerUrl,
        masterKey: ApplicationConstants.keyParseCustomerKey,
        clientKey: ApplicationConstants.keyParseCustomerKey,
        debug: true);
    var response = await Parse().healthCheck();
    if (response.success) {
      print("Success");
    } else {
      print("Server health check failed");
    }
  }

  query() async{
    QueryBuilder<ParseObject> queryBuilder = QueryBuilder<ParseObject>(ParseObject('ProductDatabase'));

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> listFromApi = apiResponse.result;
      final ParseObject parseObject = listFromApi?.first;
      print(parseObject.type.toString());
    } else {
      print('Result: ${apiResponse.error.message}');
    }
  }
}
