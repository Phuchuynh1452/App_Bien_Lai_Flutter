import 'dart:convert';
import 'dart:ffi';

// import 'dart:html';
// import 'package:appphathanhbienlai/listnoidung.dart';
import 'package:appphathanhbienlai/listnoidung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:appphathanhbienlai/models/catagoryModel.dart';
import 'package:appphathanhbienlai/models/settingModel.dart';
import 'package:appphathanhbienlai/utils/database_helper.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import 'NumberToVietnamese.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int count = 0;
  int countSetting = 0;
  int radioCategory = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  double tongtien = 0;
  double sotien = 0;
  String noidung = "";
  List<Category> categoryList;

  List<Setting> settingList;

  String fkeyHoaDon;


  TextEditingController hoten_Controller = TextEditingController();
  TextEditingController diachi_Controller = TextEditingController();
  TextEditingController soluong_Controller = TextEditingController();
  TextEditingController tongtienController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (categoryList == null || settingList == null) {
      categoryList = List<Category>();
      settingList = List<Setting>();
      updateListView();
      getSettingListView();
    }else {
      updateListView();
      getSettingListView();
    }
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (hoten_Controller.text == null ||
                  hoten_Controller.text == "") {
                showAlertDialog("Lỗi nhập liệu", "Vui lòng nhập họ và tên!");
                return;
              }
              if (diachi_Controller.text == null ||
                  diachi_Controller.text == "") {
                showAlertDialog("Lỗi nhập liệu", "Vui lòng nhập địa chỉ!");
                return;
              }
              if (radioCategory == null || radioCategory == "") {
                showAlertDialog("Lỗi nhập liệu", "Vui lòng chọn danh mục!");
                return;
              }
              if (soluong_Controller.text == null ||
                  soluong_Controller.text == "") {
                showAlertDialog("Lỗi nhập liệu", "Vui lòng nhập số lượng!");
                return;
              }

              String result = await fetchPhatHanhBienLai();
              if (result.contains("OK")) {
                showAlertDialog("Success", "Phát hành thành công!");
                String result_bienlai_64 = await fetchBienLai(fkeyHoaDon);
                // showAlertDialog("Success",result_bienlai_64);
                // String bienlai64 = layKetQuaBienLai64(result_bienlai_64);
                // createPdf(bienlai64);
              } else {
                showAlertDialog("Error", "Lỗi phát hành!");
              }
            },
            child: Icon(Icons.add),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 15, 30, 5),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextFormField(
                    controller: diachi_Controller,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                  child: Container(
                    child: Table(
                      border: TableBorder.all(),
                      defaultVerticalAlignment: TableCellVerticalAlignment
                          .middle,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Container(
                    height: 80,
                    child: getCategoryListView(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
              ],
            ),
          )
      );
    }

  ListView getCategoryListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    children: <Widget>[
                      Center(
                        child: Radio(
                            value: this.categoryList[position].id,
                            groupValue: radioCategory,
                            onChanged: (index) {
                              setState(() {
                                radioCategory = index;
                                print(radioCategory);
                                print("\n");
                                print(this.categoryList[position].price);
                                print("\n");
                                noidung = this.categoryList[position].title;
                                sotien = this.categoryList[position].price;
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
                          child: Text(this.categoryList[position].price
                              .toString().substring(
                              0, (this.categoryList[position].price
                              .toString()
                              .length - 2)).toVND()),
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
      Future<List<Category>> categoryListFuture = databaseHelper
          .getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.count = categoryList.length;
        });
      });
    });
  }

  void getSettingListView() {
    final Future<Database> dbFutute = databaseHelper.initializeDatabase();
    dbFutute.then((database) {
      Future<List<Setting>> settingListFuture = databaseHelper.getSettingList();
      settingListFuture.then((settingList) {
        setState(() {
          this.settingList = settingList;
          this.countSetting = settingList.length;
        });
      });
    });
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


//------------------------------------------------------------------------------------------------------------------------------------

  // cauhinh_Publish sẽ lấy tử item đầu tiên trong danh sách cấu hình, cauhinh_Portal sẽ lấy từ item thứ 2 trong danh sách cấu hình
  Future<String> fetchPhatHanhBienLai() async {
    final response = await http.post(
      Uri.parse('${this.settingList[0].urlservice}'),
      headers: <String, String>{
        'content-type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/ImportAndPublishInv',
      },
      body: utf8.encode(GenerateRequestBody_PhatHanhBienLai()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return layKetQuaPhatHanh(response.body);
    } else {
      showAlertDialog("Lỗi phát hành", "Có lỗi xãy ra khi phát hành biên lai");
      throw Exception('Phát hành biên lai thất bại');
    }
  }


  Future<String> fetchBienLai(String fkey) async {
    final response = await http.post(
      Uri.parse(this.settingList[0].urlservice),
      headers: <String, String>{
        'content-type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/downloadInvPDFFkeyNoPay',
      },
      body: utf8.encode(GenerateRequestBody_BienLai(fkey)),
    );
    showAlertDialog("Lỗi phát hành", response.statusCode.toString());

    // if (response.statusCode == 201 || response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   showAlertDialog("Lỗi phát hành", "Có lỗi xãy ra khi phát hành biên lai");
    //   throw Exception('Phát hành biên lai thất bại');
    // }
  }
  //
  //
  // createPdf(String base64String) async {
  //   var bytes = base64Decode(base64String.replaceAll('\n', ''));
  //   final output = await getTemporaryDirectory();
  //   String time = DateFormat('ddMMyyyykkmmssSSS').format(DateTime.now());
  //   // final file = File("${output.path}/bienlai_${time}.pdf");
  //   // await file.writeAsBytes(bytes.buffer.asUint8List());
  //   //
  //   // print("${output.path}/bienlai_${time}.pdf");
  //   // await OpenFile.open("${output.path}/bienlai_${time}.pdf");
  //
  //   setState(() {});
  // }
  //
  int calc_ranks(ranks) {
    double multiplier = .5;
    return (multiplier * ranks).round();
  }
  //
  //
  String GenerateXml() {
    fkeyHoaDon = DateFormat('ddMMyyyykkmmssSSS').format(DateTime.now());
    String arising_date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    String amountInWords = NumberToVietnamese.convert(calc_ranks(tongtien));
    String xml = '<Invoices>'
        '<Inv>'
        '<key>$fkeyHoaDon</key>'
        '<Invoice>'
        '<Buyer>Người dân</Buyer>'
        '<CusCode>1</CusCode>'
        '<CusName>${hoten_Controller.text}</CusName>'
        '<CusAddress>${diachi_Controller.text}</CusAddress>'
        '<CusPhone></CusPhone>'
        '<CusTaxCode/>'
        '<PaymentMethod>TM</PaymentMethod>'
        '<KindOfService></KindOfService>'
        '<Products>'
        '<Product>'
        '<ProdName>${noidung}</ProdName>'
        '<ProdUnit>đồng</ProdUnit>'
        '<ProdQuantity>${soluong_Controller.text}</ProdQuantity>'
        '<ProdPrice>${sotien}</ProdPrice>'
        '<Amount>$tongtien</Amount>'
        '</Product>'
        '</Products>'
        '<VATRate>-1</VATRate>'
        '<VATAmount>0</VATAmount>'
        '<Total>$tongtien</Total>'
        '<Amount>$tongtien</Amount>'
        '<AmountInWords>$amountInWords</AmountInWords>'
    //'<ArisingDate>$arising_date</ArisingDate>'
        '</Invoice>'
        '</Inv>'
        '</Invoices>';
    return xml;
  }

  //
  String GenerateRequestBody_PhatHanhBienLai() {
    String gen_xml = GenerateXml();
    String requestBody = '<x:Envelope '
        'xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" '
        'xmlns:tem="http://tempuri.org/">'
        '<x:Header/>'
        '<x:Body>'
        '<tem:ImportAndPublishInv>'
        '<tem:Account>${this.settingList[0].acaccount}</tem:Account>'
        '<tem:ACpass>${this.settingList[0].acpass}</tem:ACpass>'
        '<tem:xmlInvData><![CDATA[${gen_xml}]]></tem:xmlInvData>'
        '<tem:username>${this.settingList[0].username}</tem:username>'
        '<tem:password>${this.settingList[0].password}</tem:password>'
        '<tem:pattern>${this.settingList[0].pattern}</tem:pattern>'
        '<tem:serial>${this.settingList[0].serial}</tem:serial>'
        '<tem:convert>0</tem:convert>'
        '</tem:ImportAndPublishInv>'
        '</x:Body>'
        '</x:Envelope>';
    return requestBody;
  }

  //
  //
  String GenerateRequestBody_BienLai(String fkey) {
    String requestBody = '<x:Envelope '
        'xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" '
        'xmlns:tem="http://tempuri.org/">'
        '<x:Header/>'
        '<x:Body>'
        '<tem:downloadInvPDFFkeyNoPay>'
        '<tem:fkey>$fkey</tem:fkey>'
        '<tem:userName>${this.settingList[1].username}</tem:userName>'
        '<tem:userPass>${this.settingList[1].password}</tem:userPass>'
        '</tem:downloadInvPDFFkeyNoPay>'
        '</x:Body>'
        '</x:Envelope>';
    return requestBody;
  }

  //
  //
  String layKetQuaPhatHanh(String value) {
    String start = '<ImportAndPublishInvResult>';
    String end = '</ImportAndPublishInvResult>';
    int startIndex = value.indexOf(start);
    int endIndex = value.indexOf(end, startIndex + start.length);
    String result = value.substring(startIndex + start.length, endIndex);
    return result;
  }

  //
  //
  String layKetQuaBienLai64(String value) {
    String start = '<downloadInvPDFFkeyNoPayResult>';
    String end = '</downloadInvPDFFkeyNoPayResult>';
    int startIndex = value.indexOf(start);
    int endIndex = value.indexOf(end, startIndex + start.length);
    String result = value.substring(startIndex + start.length, endIndex);
    return result;
  }
}
