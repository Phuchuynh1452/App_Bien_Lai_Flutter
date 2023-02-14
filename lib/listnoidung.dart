import 'package:flutter/material.dart';



class Noidunglist extends StatefulWidget {

  @override
  State<Noidunglist> createState() => _NoidunglistState();
}

class _NoidunglistState extends State<Noidunglist> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getInfomationListView(),
    );
  }
  ListView getInfomationListView(){
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
              color: Colors.white,
              child: ListTile(
                trailing: GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.grey,),
                      Icon(Icons.delete, color: Colors.grey,)
                    ],
                  ),

                ),
              )
          );
        }
    );

  }
}

