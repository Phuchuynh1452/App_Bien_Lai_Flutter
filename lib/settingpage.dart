import 'package:appphathanhbienlai/models/settingModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:appphathanhbienlai/models/catagoryModel.dart';
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
                          navigateToDetailSetting(this.settingList[position]);
                        }, icon: Icon(Icons.edit, color: Colors.purple,)),
                        IconButton(onPressed: (){
                          debugPrint('ListTitle Tapped');
                          _delete(context, this.settingList[position]);
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



  void navigateToDetailSetting(Setting setting) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSetting(setting);
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
}
