import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:appphathanhbienlai/addcategory.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class CategoryPage extends StatefulWidget {
  int Count = 0;
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Category> categoryList;

  @override
  Widget build(BuildContext context) {
    if(categoryList == null){
      categoryList = List<Category>();
      updateListView();
    }else{
      updateListView();
    }

    return Scaffold(
      body: getCategoryListView(),
    );
  }

  ListView getCategoryListView(){
    TextStyle titleStyle = TextStyle(color: Colors.white);
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: Text(this.categoryList[position].title),
                subtitle: Text(this.categoryList[position].price.toString().substring(0, (this.categoryList[position].price.toString().length - 2)).toVND()),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        debugPrint('ListTitle Tapped');
                        navigateToDetail(this.categoryList[position]);
                      }, icon: Icon(Icons.edit, color: Colors.purple,)),
                      IconButton(onPressed: (){
                        debugPrint('ListTitle Tapped');
                        _delete(context, this.categoryList[position]);
                      }, icon: Icon(Icons.delete , color: Colors.redAccent)),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  void updateListView() {
    final Future<Database> dbFutute = databaseHelper.initializeDatabase();
    dbFutute.then((database) {
      Future<List<Category>> categoryListFuture = databaseHelper.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.count = categoryList.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _delete(BuildContext context, Category category) async{
    int result = await databaseHelper.deleteCategory(category.id);
    if(result != 0){
      _showSnackBar(context, 'Category Deleted Succesfully');
      updateListView();
    }
  }

  void navigateToDetail(Category category) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCategory(category);
    }));
  }
}
