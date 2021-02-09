import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cradit extends StatefulWidget {
  Cradit({Key key}) : super(key: key);

  @override
  _CraditState createState() => _CraditState();
}

class _CraditState extends State<Cradit> with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isLoading = false;
  List<dynamic> cradit = [];
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCashMember_M();
    //tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //tabController.dispose();
  }

  _getCashMember_M() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getCashMember_M';
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
    if (response.statusCode == 200) {
      final Map<String, dynamic> craditdata = convert.jsonDecode(response.body);
      if (craditdata['code'] == "200") {
        //print(craditdata);
        setState(() {
          cradit = craditdata['data'];
        });
        print(cradit);
      } else {

      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    print(data);
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
        toolbarHeight: 120,
        //backgroundColor: Colors.grey,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Icon(Icons.account_circle, size: 38,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    "ยอดเครดิต ${data['credit']}", 
                    style: TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
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
        // bottom: TabBar(
        //   controller: tabController,
        //   unselectedLabelColor: Colors.black,
        //   labelColor: Colors.white,
        //   indicatorWeight: 5.0,
        //   indicatorSize: TabBarIndicatorSize.label,
        //   tabs: [
        //     Tab(text: "ข้อมูลเครดิต",),
        //     Tab(text: "รายการ",),
        //   ],
        // ),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: true,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: cradit.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: Text(
                          cradit[index]['date'],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                  
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            //padding: EdgeInsets.only(left: 40.0, right: 40.0),
                            itemCount: cradit[index]['data'].length,
                            itemBuilder: (BuildContext context, int index1){
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0,),
                                child: Card(
                                  color: Colors.grey[800],
                                  child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "จำนวนเงิน : ${cradit[index]['data'][index1]['amount'].toString()}",
                                        style: TextStyle (
                                          color: Colors.white, fontSize: 14.5
                                        ),
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                        "ชื่อผู้ทำรายการ : ${cradit[index]['data'][index1]['username']}",
                                        style: TextStyle (
                                          color: Colors.white, fontSize: 14.5
                                        ),
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                        "ชื่อกระดาน : ${cradit[index]['data'][index1]['board']}",
                                        style: TextStyle (
                                          color: Colors.white, fontSize: 14.5
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
                                    ],
                                  ),
                                  subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "วันที่ทำรายการ ${cradit[index]['data'][index1]['createdDate']}",
                                            style: TextStyle (
                                                color: Colors.white, fontSize: 13.5
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Text(
                                            "เวลา ${cradit[index]['data'][index1]['createdTime']}",
                                            style: TextStyle (
                                                color: Colors.white, fontSize: 12.5
                                            ),
                                          ),
                                        ],
                                      ),
                                ),),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }
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
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        //launch(('tel://${item.mobile_no}'));
                        //launch(('tel://0922568260'));
                        launch(('tel://${data['board_phone_1']}'));
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
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Helpadvice();}
                          ),
                        );
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
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/noti", arguments: {
                              'total_noti': data['total_noti'],
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: data['total_noti'] == null ? SizedBox(height: 2.0,)
                        :data['total_noti'] == 0 ? SizedBox(height: 2.0,)
                        :CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            data['total_noti'].toString(),
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
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Coin();}
                          ),
                        );
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