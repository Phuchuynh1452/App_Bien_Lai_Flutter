import 'dart:ffi';

import 'package:appphathanhbienlai/listnoidung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/number_symbols_data.dart';
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
  double tongtien = 0;
  double sotien = 0;
  List<Category> categoryList;


  TextEditingController hoten_Controller = TextEditingController();
  TextEditingController diachi_Controller = TextEditingController();
  TextEditingController soluong_Controller = TextEditingController();
  TextEditingController tongtienController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if(categoryList == null){
      categoryList = List<Category>();
      updateListView();
    }else{
      updateListView();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(hoten_Controller.text == null || hoten_Controller.text == ""){
            showAlertDialog("Vui lòng nhập họ và tên!");
            return;
          }
          if (diachi_Controller.text == null || diachi_Controller.text == ""){
            showAlertDialog("Vui lòng nhập địa chỉ!");
            return;
          }
          if (radioCategory == null || radioCategory == ""){
            showAlertDialog("Vui lòng chọn danh mục!");
            return;
          }
          if (soluong_Controller.text == null || soluong_Controller.text == ""){
            showAlertDialog("Vui lòng nhập số lượng!");
            return;
          }

          // String result = await fetchPhatHanhBienLai();
          // if (result.contains("OK")) {
          //   String result_bienlai_64 = await fetchBienLai(fkeyHoaDon!);
          //   String bienlai64 = layKetQuaBienLai64(result_bienlai_64);
          //   createPdf(bienlai64);
          // } else {
          //   showAlertDialog("Lỗi phát hành!");
          // }
        },
          child: Icon(Icons.add),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(20, 15, 30, 20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: TextFormField(
                controller: hoten_Controller,
                decoration: InputDecoration(
                  labelText: "Nhập họ tên",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: TextFormField(
                controller: diachi_Controller,
                decoration: InputDecoration(
                  labelText: "Nhập địa chỉ",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
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
                height: 100,
                child: getCategoryListView(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: TextFormField(
                controller: soluong_Controller,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: "Nhập số lượng",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Colors.grey),
                  ),
                ),
                onChanged: (value){
                  debugPrint('Something changed in quantity Text Field');
                  // tongtien = tongtien * double.parse();
                  if(soluong_Controller.text != ""){
                    print( tongtien = sotien * num.tryParse(soluong_Controller.text)?.toDouble());
                  }
                },
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0,0, 0, 0),
                  alignment: AlignmentDirectional.topStart,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                        child:
                        Text("Tổng tiền:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Text("$tongtien".toString().substring(0, ("$tongtien".toString().length - 2)).toVND(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  )
              ),
            )
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
                              value: this.categoryList[position].id, groupValue: radioCategory,
                              onChanged: (index) {
                                setState(() {
                                  radioCategory = index;
                                  print(radioCategory);
                                  print("\n");
                                  print(this.categoryList[position].price);
                                  print("\n");

                                  sotien = this.categoryList[position].price;
                                });
                              }
                          ),
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

  Future<void> showAlertDialog(String message) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Lỗi nhập liệu"),
        content: Text("$message"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(14),
              child: const Text("OK",style: TextStyle(
                  color: Colors.white
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
