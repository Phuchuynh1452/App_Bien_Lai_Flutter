import 'package:flutter/material.dart';
import 'dart:async';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:appphathanhbienlai/models/settingModel.dart';
class AddSetting extends StatefulWidget {
  final Setting setting;
  final String apptitle;
  AddSetting(this.setting, this.apptitle);
  @override
  State<AddSetting> createState() => _AddSettingState(this.setting, this.apptitle);
}

class _AddSettingState extends State<AddSetting> {
  DatabaseHelper helper = DatabaseHelper();
  Setting setting;
  String apptitle;

  TextEditingController urlServiceController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController acaccountController = TextEditingController();
  TextEditingController acpassController = TextEditingController();
  TextEditingController patternController = TextEditingController();
  TextEditingController serialController = TextEditingController();

  _AddSettingState(this.setting, this.apptitle);
  @override
  Widget build(BuildContext context) {
    urlServiceController.text = setting.urlservice;
    usernameController.text = setting.username;
    passwordController.text = setting.password;
    acaccountController.text = setting.acaccount;
    acpassController.text = setting.acpass;
    patternController.text = setting.pattern;
    serialController.text = setting.serial;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(apptitle),
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
                  if(urlServiceController.text == null || urlServiceController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập url service");
                    return;
                  }
                  if(usernameController.text == null || usernameController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập username");
                    return;
                  }
                  if(passwordController.text == null || passwordController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập password");
                    return;
                  }
                  if(acaccountController.text == null || acaccountController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập ac account");
                    return;
                  }
                  if(acpassController.text == null || acpassController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập ac pass");
                    return;
                  }
                  if(patternController.text == null || patternController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập pattern");
                    return;
                  }
                  if(serialController.text == null || serialController.text == ""){
                    showAlertDialog("Tạo cấu hình lỗi", "Vui lòng nhập serial");
                    return;
                  }
                  _save();
                },
                icon: Icon(Icons.save),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 30, 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: urlServiceController,
                  decoration: InputDecoration(
                    labelText: "Nhâp url service",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in url Text Field');
                    updateUrlService();
                  },
                  keyboardType: TextInputType.url,

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Nhập username",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updateUsername();
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(

                    labelText: "Nhập password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updatePassword();
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: acaccountController,
                  decoration: InputDecoration(
                    labelText: "Nhập ac acount",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updateAcacount();
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  obscureText: true,
                  controller: acpassController,
                  decoration: InputDecoration(
                    labelText: "Nhập ac pass",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updateAcpass();
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: patternController,
                  decoration: InputDecoration(
                    labelText: "Nhập pattern",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updatePattern();
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: serialController,
                  decoration: InputDecoration(
                    labelText: "Nhập serial",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.grey),
                    ),
                  ),
                  onChanged: (value){
                    debugPrint('Something changed in Price Text Field');
                    updateSerial();
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

  void updateUrlService(){
    setting.urlservice = urlServiceController.text;
  }
  void updateUsername(){
    setting.username = usernameController.text;
  }
  void updatePassword(){
    setting.password = passwordController.text;
  }
  void updateAcacount(){
    setting.acaccount = acaccountController.text;
  }
  void updateAcpass(){
    setting.acpass = acpassController.text;
  }
  void updatePattern(){
    setting.pattern = patternController.text;
  }
  void updateSerial(){
    setting.serial = serialController.text;
  }

  void _save() async{
    moveToLastScreen();

    int result;
    if(setting.id != null){ //Case 1 update operation
      result = await helper.updateSetting(setting);
    }else{ //Case 2 insert operation
      result = await helper.insertSetting(setting);
    }




    if(result != 0){ //Succes
      _showAlterDialog('Status','Setting Saved Successfully');
    }else{ //Failure
      _showAlterDialog('Status','Problem Saving Setting');
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text("$title"),
            content: Text("$message"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK", style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ),
            ],
          ),
    );
  }


}
