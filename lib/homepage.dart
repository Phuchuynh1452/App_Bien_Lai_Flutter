import 'package:appphathanhbienlai/listnoidung.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  int radioCategory = 0;
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

      body:  Container(
        padding: EdgeInsets.fromLTRB(20, 15, 30, 5),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nhập họ tên",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.name,

              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nhập địa chỉ",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),

              child: Container(
                child: Table(
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 32,
                              child: Text("Nội dung"),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 32,
                              child: Text("Số tiền"),
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: Container(
                height: 80,
                child: getCategoryListView(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nhập số lượng",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Tổng tiền",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
            ),
          ],
        ),
      )
    );
  }


  ListView getCategoryListView(){
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
              color: Colors.white,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                      children: <Widget>[
                        Center(
                          child: Radio(
                              value: this.categoryList[position].id, groupValue: radioCategory, onChanged: (index) {
                                setState(() {
                                  radioCategory = index;
                                  print(radioCategory);
                            });
                          }),
                        ),
                        Center(
                          child: Container(
                            height: 32,
                            child: Text(this.categoryList[position].title),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 32,
                            child: Text(this.categoryList[position].price.toString().substring(0, (this.categoryList[position].price.toString().length - 2)).toVND()),
                          ),
                        ),
                      ]
                  )
                ],
              ),
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
}
