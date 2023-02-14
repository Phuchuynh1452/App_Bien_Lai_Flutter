import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:appphathanhbienlai/models/settingModel.dart';


class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  // String Category Table
  String categoryTable = 'category_table';
  String colId = 'id';
  String colTitle = 'title';
  String colPrice = 'price';

  // String Setting Table
  String settingTable = 'setting_table';
  String colIdSetting = 'id';
  String colUrlService = 'url_service';
  String colUsername = 'username';
  String colPassword = 'password';
  String colAcaccount = 'acaccount';
  String colAcpass = 'acpass';
  String colPattern = 'pattern';
  String colSerial = 'serial';
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if( _databaseHelper == null ){
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'exportReceipt2s.db';

    var exportReceiptsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return exportReceiptsDatabase;
  }



  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $categoryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colPrice double)');
    await db.execute('CREATE TABLE $settingTable($colIdSetting INTEGER PRIMARY KEY AUTOINCREMENT, $colUrlService TEXT, '
        '$colUsername TEXT, $colPassword TEXT, $colAcaccount TEXT, $colAcpass TEXT, $colPattern TEXT, $colSerial TEXT)');
  }

  //-------------------------------------------Category-----------------------------------------

  //Fecth Operation: Get all category object from database
  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPiority ASC');
    var result = await db.query(categoryTable, orderBy: '$colId ASC');

    return result;
  }

  //Insert category table
  Future<int> insertCategory(Category category) async{
    Database db = await this.database;
    var result = await db.insert(categoryTable, category.toMap());
    return result;
  }

  //Update category table
  Future<int> updateCategory(Category category) async{
    var db = await this.database;
    var result = await db.update(categoryTable, category.toMap(), where: '$colId = ?', whereArgs: [category.id]);
    return result;
  }

  //Delete category table
  Future<int> deleteCategory(int id) async{
    var db = await this.database;
    var result = await db.rawDelete('Delete from $categoryTable Where $colId = $id');
    return result;
  }

  //get Number category table
  Future<int> getCountCategory() async{
    Database db = await this.database;

    List<Map<String, dynamic>> x = await db.rawQuery('Select count(*) from $categoryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get the 'Map List' [List<Map>] and convert it to 'Category List' [List<Category>]
  Future<List<Category>> getCategoryList() async{
    var categoryMapList = await getCategoryMapList();
    int count = categoryMapList.length;

    List<Category> categoryList = List<Category>();
    //For loop to create a 'Note List'  from a 'Map List'
    for(int i = 0; i<count; i++){
      categoryList.add(Category.fromMapObject(categoryMapList[i]));
    }
    return categoryList;
  }


  //-------------------------------------Setting Table---------------------------------------

//Fecth Operation: Get all category object from database
  Future<List<Map<String, dynamic>>> getSettingMapList() async {
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPiority ASC');
    var result = await db.query(settingTable, orderBy: '$colIdSetting ASC');

    return result;
  }

  //Insert category table
  Future<int> insertSetting(Setting setting) async{
    Database db = await this.database;
    var result = await db.insert(settingTable, setting.toMap());
    return result;
  }

  //Update category table
  Future<int> updateSetting(Setting setting) async{
    var db = await this.database;
    var result = await db.update(settingTable, setting.toMap(), where: '$colIdSetting = ?', whereArgs: [setting.id]);
    return result;
  }

  //Delete category table
  Future<int> deleteSetting(int id) async{
    var db = await this.database;
    var result = await db.rawDelete('Delete from $settingTable Where $colIdSetting = $id');
    return result;
  }

  //get Number category table
  Future<int> getCountSetting() async{
    Database db = await this.database;

    List<Map<String, dynamic>> x = await db.rawQuery('Select count(*) from $settingTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get the 'Map List' [List<Map>] and convert it to 'Category List' [List<Category>]
  Future<List<Setting>> getSettingList() async{
    var settingMapList = await getSettingMapList();
    int count = settingMapList.length;

    List<Setting> settingList = List<Setting>();
    //For loop to create a 'Note List'  from a 'Map List'
    for(int i = 0; i<count; i++){
      settingList.add(Setting.fromMapObject(settingMapList[i]));
    }
    return settingList;
  }
}