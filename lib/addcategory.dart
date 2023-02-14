import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:intl/intl.dart';

class AddCategory extends StatefulWidget {
  final Category category;
  AddCategory(this.category);
  @override
  State<AddCategory> createState() => _AddCategoryState(this.category);
}

class _AddCategoryState extends State<AddCategory> {
  DatabaseHelper helper = DatabaseHelper();
  Category category;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  _AddCategoryState(this.category);
  @override
  Widget build(BuildContext context) {

    titleController.text = category.title;
    priceController.text = category.price.toString();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Danh mục - Thêm mới"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent
              ),
              child: IconButton(
                onPressed: (){
                  debugPrint("Save button clicked");
                  _save();
                },
                icon: Icon(Icons.save),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,30),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Nhâp tên danh mục",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  keyboardType: TextInputType.name,

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,30),
                child: TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Nhập mệnh giá",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updatePrice();
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }



  void _showAlterDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  //Update the title of Note Object
  void updateTitle(){
    category.title = titleController.text;
  }

  //Update the description of Note Object
  void updatePrice(){
    category.price = double.parse(priceController.text);
  }

  void _save() async{
    moveToLastScreen();

    int result;
    if(category.id != null){ //Case 1 update operation
      result = await helper.updateCategory(category);
    }else{ //Case 2 insert operation
      result = await helper.insertCategory(category);
    }


    if(result != 0){ //Succes
      _showAlterDialog('Status','Category Saved Successfully');
    }else{ //Failure
      _showAlterDialog('Status','Problem Saving Category');
    }
  }


}
