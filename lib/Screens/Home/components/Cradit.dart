import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

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
  String title = "มีข้อผิดพลาดจากระบบ";

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
          setState(() {
            isLoading = false;
          });
        });
        //print(cradit);
      } else {
        setState(() {
          isLoading = false;
        });
          
        showDialog(
          context: context,
          builder: (context) => dialog1(
            title, context
            // context: context,
            // title: 'Logout',
            // content: 'Are you sure you want to exit!!!',
            // action1: 'cancel',
            // action2: 'yes',
            // div: false,
            // txtAlign: 2,
            // radius: 0.0,
            // boxColor: Colors.green,
            // btnTxtColor: Colors.white,
            // txtColor: Colors.white,
          ),
        );
      }
      
    } else {
      showDialog(
        context: context,
        builder: (context) => dialog1(
          title, context
        ),
      ); 
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print(data);
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
        //toolbarHeight: 120,
        //backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text(
          "ยอดเครดิต ${data['credit']}", 
          style: TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold)
        ),
        // title: Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         // Padding(
        //         //   padding: EdgeInsets.symmetric(horizontal: 1),
        //         //   child: Icon(Icons.account_circle, size: 38,),
        //         // ),
        //         Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 3),
        //           child: Text(
        //             "ยอดเครดิต ${data['credit']}", 
        //             style: TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold)
        //           ),
        //         ),
        //       ],
        //     ),
        //     // SizedBox(height: 8,),
        //     // Row(
        //     //   mainAxisAlignment: MainAxisAlignment.end,
        //     //   children: [
        //     //     Text(
        //     //       "ข้อมูล ณ เวลา 06:04",
        //     //       style: TextStyle(color: kTextColor, fontSize: 12.0, fontWeight: FontWeight.bold)
        //     //     ),
        //     //   ],
        //     // ),
        //   ],
        // ),
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
      body: isLoading == true ? 
      Center(
        child: CircularProgressIndicator(),
      )
      :cradit.length == 0 ?
      Center(
        child: Text(
          "ไม่พบข้อมูล", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      )
      :SafeArea(
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
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          cradit[index]['date'],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                  
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                      child: Column(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            //padding: EdgeInsets.only(left: 40.0, right: 40.0),
                            itemCount: cradit[index]['data'].length,
                            itemBuilder: (BuildContext context, int index1){
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0,),
                                child: Card(
                                  //color: Colors.grey[800],
                                  child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "จำนวนเงิน : ${cradit[index]['data'][index1]['amount'].toString()}",
                                        style: TextStyle (
                                          color: Colors.black, fontSize: 14.5
                                        ),
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                        "ชื่อผู้ทำรายการ : ${cradit[index]['data'][index1]['username']}",
                                        style: TextStyle (
                                          color: Colors.black, fontSize: 14.5
                                        ),
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                        "ชื่อกระดาน : ${cradit[index]['data'][index1]['board']}",
                                        style: TextStyle (
                                          color: Colors.black, fontSize: 14.5
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
                                                color: Colors.black, fontSize: 13.5
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Text(
                                            "เวลา ${cradit[index]['data'][index1]['createdTime']}",
                                            style: TextStyle (
                                                color: Colors.black, fontSize: 12.5
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
                          'member_point': data['member_point'],
                          'board_phone_1': data['board_phone_1'],
                          'total_noti': data['total_noti'],
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
                              'member_point': data['member_point'],
                              'board_phone_1': data['board_phone_1'],
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
                          'member_point': data['member_point'],
                          'board_phone_1': data['board_phone_1'],
                          'total_noti': data['total_noti'],
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