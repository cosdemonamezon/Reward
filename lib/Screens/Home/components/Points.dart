import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Points extends StatefulWidget {
  Points({Key key}) : super(key: key);

  @override
  _PointsState createState() => _PointsState();
}

class _PointsState extends State<Points> {
  bool isLoading = false;
  List<dynamic> point = [];
  SharedPreferences prefs;

  @override
  void initState() { 
    super.initState();
    _getPointIncome();
  }

  _getPointIncome() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = 'http://103.74.253.96/reward-api/public/api/getPointIncome_M';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id']
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> pointdata = convert.jsonDecode(response.body);
      if(pointdata['code'] == "200"){
        print(pointdata['massage']);
        setState((){
          point = pointdata['data'];
          
          print(point[3]['date']);
          print(point[3]['data'][1]['deposit_point']);
          //print(point[0]['data'][0]['deposit_point']);
          // print(point[1]['data'][0]['deposit_point']);
          // print(point[0]['date']);
          // print(point[1]['date']);
          // print(point[2]['date']);
          // print(point[3]['date']);
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }
    else{
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.grey,
        title: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Icon(Icons.account_circle, size: 50,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Point ${data['member_sum_point']}", 
                    style: TextStyle(color: kTextColor, fontSize: 24.0, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ข้อมูล ณ เวลา 06:04",
                  style: TextStyle(color: kTextColor, fontSize: 12.0, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20,),
                        child: Text(point[index]['date']),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: point[index]['data'].length,
                          itemBuilder: (BuildContext context, int index1){
                            return Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("เติมเงินรับฟรี", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                    Text(
                                      point[index]['data'][index1]['deposit_point'].toString(), 
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                    ),
                                    //Text("???", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("21:54 น.", style: TextStyle(fontSize: 10.0)),
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(), 
          itemCount: point.length
          //itemCount: point.length.compareTo(0)
        ),
      ),
    );
  }
}