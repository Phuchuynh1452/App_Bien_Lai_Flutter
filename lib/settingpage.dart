import 'package:appphathanhbienlai/models/settingModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:appphathanhbienlai/addsetting.dart';
class SettingPage extends StatefulWidget {

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Setting> settingList;
  @override
  Widget build(BuildContext context) {
    if(settingList == null){
      settingList = List<Setting>();
      updateListView();
    }else{
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cấu hình"),
        actions: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent
            ),
            child: IconButton(
              onPressed: () async {
                navigateToDetailSetting(Setting('','','','','','',''), "Cấu hình - Thêm mới");
              },
              icon: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: getSettingListView(),
    );
  }

  ListView getSettingListView(){
    TextStyle titleStyle = TextStyle(color: Colors.white);
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Container(
            margin: EdgeInsets.only(top: 5),
            child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 3,
                      color: Colors.black87,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  title: Text(this.settingList[position].urlservice + "\n"
                      "${this.settingList[position].username} \n"
                      "${this.settingList[position].password} \n"
                      "${this.settingList[position].acaccount} \n"
                      "${this.settingList[position].acpass} \n"
                      "${this.settingList[position].pattern} \n"
                      "${this.settingList[position].serial} ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          debugPrint('ListTitle Tapped');
                          navigateToDetailSetting(this.settingList[position], "Cấu hình - Cập nhật");
                        }, icon: Icon(Icons.edit, color: Colors.purple,)),
                        IconButton(onPressed: (){
                          debugPrint('ListTitle Tapped');
                          showAlertDialog(context, this.settingList[position]);
                        }, icon: Icon(Icons.delete , color: Colors.redAccent)),
                      ],
                    ),
                  ),
                )
            ),
          );
        }
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  void navigateToDetailSetting(Setting setting, String apptitle) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSetting(setting, apptitle);
    }));
  }

  void _delete(BuildContext context, Setting setting) async{
    int result = await databaseHelper.deleteSetting(setting.id);
    if(result != 0){
      _showSnackBar(context, 'Setting Deleted Succesfully');
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFutute = databaseHelper.initializeDatabase();
    dbFutute.then((database) {
      Future<List<Setting>> settingListFuture = databaseHelper.getSettingList();
      settingListFuture.then((settingList) {
        setState(() {
          this.settingList = settingList;
          this.count = settingList.length;
        });
      });
    });
  }

  showAlertDialog(BuildContext context, Setting setting) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Đóng"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Xóa"),
      onPressed:  () {
        _delete(context, setting);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Xóa cấu hình"),
      content: Text("Bạn muốn xóa cấu hình đang chọn?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
