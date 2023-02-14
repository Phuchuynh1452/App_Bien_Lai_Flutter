import 'package:appphathanhbienlai/addcategory.dart';
import 'package:appphathanhbienlai/addsetting.dart';
import 'package:appphathanhbienlai/categorypage.dart';
import 'package:appphathanhbienlai/homepage.dart';
import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:appphathanhbienlai/models/settingModel.dart';
import 'package:appphathanhbienlai/settingpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  static String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyStatefulWidgetState();
  }
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  List Pages = [
    HomePage(),
    SettingPage(),
    CategoryPage(),
  ];

  List<String> _appbartitileList = ["Phát hành","Cấu hình","Danh mục"];
  List<Icon> _iconList = [
    Icon(Icons.upload),
    Icon(Icons.add),
    Icon(Icons.add),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _AppbarButtonOnPress(){
    if(_selectedIndex==0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Trả về biên lai"),
      ));
    }
    else if(_selectedIndex==1){
      navigateToDetailSetting(Setting('','','','','','',''));
    }else if(_selectedIndex==2){
      navigateToDetail(Category('',0));
    }
   }

  @override
  Widget build(BuildContext context) {
    String _appbartitle =_appbartitileList.elementAt(_selectedIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text(_appbartitle),
        actions: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent
            ),
            child: IconButton(
              onPressed: (){
                _AppbarButtonOnPress();
              },
              icon: _iconList.elementAt(_selectedIndex),
            ),
          )
        ],
      ),
      body: Center(
        child: Pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
                Icons.upload,
            ),
            label: 'Phát hành',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cấu hình',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Danh mục',
            backgroundColor: Colors.white,
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void navigateToDetail(Category category) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCategory(category);
    }));

    if( result == true){
      setState(() {
        _selectedIndex = 2;
      });
    }
  }

  void navigateToDetailSetting(Setting setting) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSetting(setting);
    }));

    if( result == true){
      setState(() {
        _selectedIndex = 1;
      });
    }
  }
}
