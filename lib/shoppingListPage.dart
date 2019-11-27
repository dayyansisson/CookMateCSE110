import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {

  Future<List<DB.ShoppingList>> _slFuture;

  @override void initState() {

    DB.DatabaseHelper db = DB.DatabaseHelper.instance;
    _slFuture = db.shoppingListItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _slFuture,
        builder: (futureContext, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.waiting:
              return CookmateStyle.loadingIcon("Loading your shopping list...");
            case ConnectionState.done:
              return shoppingListView(snapshot.data);
            default:
              return Center(child: Text("error"));
          }
        },
      ),
    );
  }

  Widget shoppingListView (List<DB.ShoppingList> list) {

    if(list.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Looks like your shopping list is empty!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: CookmateStyle.textGrey
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.shopping_cart,
                color: CookmateStyle.iconGrey,
                size: 40,
              ),
            )
          ],
        )
      );
    }

    List<Widget> items = List<Widget>();
    for(DB.ShoppingList item in list) {
      // TODO: Create shopping list items
    }

    return ListView(children: items);
  }
}