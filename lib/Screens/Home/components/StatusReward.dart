import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';


class StatusReward extends StatefulWidget {
  StatusReward({Key key}) : super(key: key);

  @override
  _StatusRewardState createState() => _StatusRewardState();
}

class _StatusRewardState extends State<StatusReward> {
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> data = [];
  

  @override
  void initState() { 
    super.initState();
    _getlogGroupMember();
  }

  _getlogGroupMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getlogGroupMember';
   
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
      final Map<String, dynamic> statusdata = convert.jsonDecode(response.body);
      if (statusdata['code'] == "200") {
        setState(() {
          data = statusdata['data'];
          setState(() {
            isLoading = false;
          });
        });
        print(data);
      }else {
        setState(() {
          isLoading = false;
        });
       showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            statusdata['massage'],
            picDenied,
            context,
          ),
        );
      }
    }
    else{
      
      final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            coindata['massage'],
            picDenied,
            context,
          ));
    }
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data2 = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Status Group Reward"),
      ),
      body: isLoading == true ? 
      Center(
        child: CircularProgressIndicator(),
      )
      :data.length == 0 ? 
      Center(
        child: Text(
          "ไม่พบข้อมูล", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF01579B)),
        ),
      )
      :Container(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                Card(
                  elevation: 8.0,
                  //color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(
                            //     width: 50.0,
                            //     height: 50.0,
                            //     decoration: new BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         image: new DecorationImage(
                            //             fit: BoxFit.cover,
                            //             image: AssetImage("assets/images/gold.JPG")
                            //         )
                            //     )
                            //   ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Member ID : ${data[index]['member_id']}',
                                  style: TextStyle (
                                      color: Colors.black,
                                      fontSize: 13.5
                                  ),
                                ),
                                Text('Old Group : ${data[index]['old_group']}',
                                  style: TextStyle (
                                      color: Colors.black,
                                      fontSize: 13.5
                                  ),
                                ),
                                Text('Update By : ${data[index]['updated_by']}',
                                  style: TextStyle (
                                      color: Colors.black,
                                      fontSize: 13.5
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${data[index]['date']}',
                              style: TextStyle (
                                color: Colors.black,
                                fontSize: 11.5
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                  ),
                ),
              ],
            );
          },          
          itemCount: data.length
        ),
      ),

      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(30.0),
          //   topRight: Radius.circular(30.0),
          // ),
          color: kNavigationBarColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 15.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    foregroundColor: nbtn1 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = true;
                          nbtn2 = false;
                          nbtn3 = false;
                          nbtn4 = false;
                        });
                        //launch(('tel://${item.mobile_no}'));
                        //launch(('tel://0922568260'));
                        launch(('tel://${data2['board_phone_1']}'));
                      },
                    ),
                  ),
                  Text(
                    "ติดต่อเรา", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    foregroundColor: nbtn2 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = false;
                          nbtn2 = true;
                          nbtn3 = false;
                          nbtn4 = false;
                        });
                        Navigator.pushNamed(context, "/help", arguments: {
                          'member_point': data2['member_point'],
                          'board_phone_1': data2['board_phone_1'],
                          'total_noti': data2['total_noti'],
                        });
                      },
                    ),
                  ),
                  Text(
                    "ช่วยแนะนำ", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        foregroundColor: nbtn3 == true ? Colors.red : Colors.white,
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              nbtn1 = false;
                              nbtn2 = false;
                              nbtn3 = true;
                              nbtn4 = false;
                            });
                            Navigator.pushNamed(context, "/noti", arguments: {
                              'member_point': data2['member_point'],
                              'board_phone_1': data2['board_phone_1'],
                              'total_noti': data2['total_noti'],
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: data2['total_noti'] == null ? SizedBox(height: 2.0,)
                        :data2['total_noti'] == 0 ? SizedBox(height: 2.0,)
                        :CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                           data2['total_noti'].toString(),
                            style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  Text(
                    "แจ้งเตือน", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    foregroundColor: nbtn4 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = false;
                          nbtn2 = false;
                          nbtn3 = false;
                          nbtn4 = true;
                        });
                        Navigator.pushNamed(context, "/coin", arguments: {
                          'member_point': data2['member_point'],
                          'board_phone_1': data2['board_phone_1'],
                          'total_noti': data2['total_noti'],
                        });
                      },
                    ),
                  ),
                  Text(
                    "เหรียญ", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}