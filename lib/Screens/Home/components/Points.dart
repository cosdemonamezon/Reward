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
          
          // print(point);
          // print(point[0]['date']);
          // print(point[0]['data'][0]['deposit_by']);
          // print(point[1]['date']);
          // print(point[1]['data'][0]['deposit_by']);
          // print(point[2]['date']);
          // print(point[2]['data'][0]['deposit_by']);
          // print(point[3]['date']);
          // print(point[3]['data'][0]['deposit_by']);
          // print(point[4]['date']);
          // print(point[4]['data'][0]['deposit_by']);
          // print(point[5]['date']);
          // print(point[5]['data'][0]['deposit_by']);
          // print(point[5]['data'][1]['deposit_by']);
          // print(point[5]['data'][2]['deposit_by']);
          // print(point[5]['data'][3]['deposit_by']);
          // print(point[5]['data'][4]['deposit_by']);
          
          
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //       "ข้อมูล ณ เวลา 06:04",
            //       style: TextStyle(color: kTextColor, fontSize: 12.0, fontWeight: FontWeight.bold)
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      //SingleChildScrollView
      body: SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: true,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: point.length,
            itemBuilder: (BuildContext context, int index){
              print(point.length);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20,),
                        child: Text(
                          point[index]['date'],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                        ),
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
                              // return Text(point[index]['data'][index1]['deposit_point'].toString());
                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      point[index]['data'][index1]['deposit_by'], 
                                      style: TextStyle(fontSize: 14.0,)
                                    ),
                                    SizedBox(height: 7.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Point",
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)
                                        ),
                                        SizedBox(width: 5.0,),
                                        Text(
                                          point[index]['data'][index1]['deposit_point'].toString(), 
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5.0,),
                                        Icon(Icons.star_border_purple500_sharp),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(point[index]['data'][index1]['date'], style: TextStyle(fontSize: 10.0)),
                                    SizedBox(width: 5.0,),
                                    Text(point[index]['data'][index1]['createdTime'], style: TextStyle(fontSize: 10.0)),
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
              );
            },
            // separatorBuilder: (BuildContext context, int index) => Divider(), 
            // itemCount: point.length
            //itemCount: point.length.compareTo(0)
          ),
      ),
    );
  }
}