import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Points extends StatefulWidget {
  Points({Key key}) : super(key: key);

  @override
  _PointsState createState() => _PointsState();
}

class _PointsState extends State<Points> {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  bool isLoading = false;
  List<dynamic> point = [];
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  Map<String, dynamic> numberNoti = {};

  @override
  void initState() {
    super.initState();
    _getPointIncome();
  }

  _getPointIncome() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    prefsNoti = await SharedPreferences.getInstance();
    var notiString = prefsNoti.getString('notification');
    var noti = convert.jsonDecode(notiString);

    setState(() {
      isLoading = true;
      numberNoti = noti['data'];
    });
    var url = pathAPI + 'api/getPointIncome_M';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> pointdata = convert.jsonDecode(response.body);
      if (pointdata['code'] == "200") {
        //print(pointdata['massage']);
        setState(() {
          point = pointdata['data'];
          setState(() {
            isLoading = false;
          });
        });
      } else if (pointdata['code'] == "400") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            pointdata['massage'],
            picDenied,
            context,
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          title,
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#" + template_kNavigationBarColor),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Point ${data['member_point']}",
            style: TextStyle(
                color: kTextColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold)),
        //toolbarHeight: 120,
        //backgroundColor: Colors.grey,
        // title: Column(
        //   children: [
        //     Row(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 1),
        //           child: Icon(Icons.account_circle, size: 50,),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 10),
        //           child: Text(
        //             "Point ${data['member_point']}",
        //             style: TextStyle(color: kTextColor, fontSize: 24.0, fontWeight: FontWeight.bold)
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(height: 15,),
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
      ),
      //SingleChildScrollView
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : point.length == 0
              ? Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hexToColor(
                            "#" + template_kNavigationFooterBarColor)),
                  ),
                )
              : SafeArea(
                  top: true,
                  bottom: true,
                  left: false,
                  right: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: point.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(point.length);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(point[index]['date'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 22.0),
                            child: Column(
                              children: [
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: point[index]['data'].length,
                                    itemBuilder:
                                        (BuildContext context, int index1) {
                                      // return Text(point[index]['data'][index1]['deposit_point'].toString());
                                      return Card(
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  point[index]['data'][index1]
                                                      ['deposit_by'],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  )),
                                              SizedBox(
                                                height: 7.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text("Point",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    point[index]['data'][index1]
                                                            ['deposit_point']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Icon(Icons
                                                      .star_border_purple500_sharp),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  point[index]['data'][index1]
                                                      ['date'],
                                                  style: TextStyle(
                                                      fontSize: 10.0)),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                  point[index]['data'][index1]
                                                      ['createdTime'],
                                                  style: TextStyle(
                                                      fontSize: 10.0)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                //SizedBox(height: 10.0,),
                              ],
                            ),
                          ),
                          //SizedBox(height: 10.0,),
                        ],
                      );
                    },
                    // separatorBuilder: (BuildContext context, int index) => Divider(),
                    // itemCount: point.length
                    //itemCount: point.length.compareTo(0)
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
          color: hexToColor("#" + template_kNavigationBarColor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 15.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor:nbtn1 == true ?
                       Colors.white54  : hexToColor("#" + template_kNavigationFooterBarColor),
                    foregroundColor: nbtn1 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          nbtn1 = true;
                          nbtn2 = false;
                          nbtn3 = false;
                          nbtn4 = false;
                        });
                        //launch(('tel://${item.mobile_no}'));
                        //launch(('tel://0922568260'));
                        launch(('tel://${numberNoti['board_phone_1']}'));
                      },
                    ),
                  ),
                  Text(
                    "ติดต่อเรา",
                    style: TextStyle(
                        color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        hexToColor("#" + template_kNavigationFooterBarColor),
                    foregroundColor: nbtn2 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
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
                    "ช่วยแนะนำ",
                    style: TextStyle(
                        color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: hexToColor(
                            "#" + template_kNavigationFooterBarColor),
                        foregroundColor:
                            nbtn3 == true ? Colors.red : Colors.white,
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: () {
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
                        child: data['total_noti'] == null
                            ? SizedBox(
                                height: 2.0,
                              )
                            : data['total_noti'] == 0
                                ? SizedBox(
                                    height: 2.0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 10,
                                    child: Text(
                                      data['total_noti'].toString(),
                                      style: TextStyle(
                                          color: kTextColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                  Text(
                    "แจ้งเตือน1",
                    style: TextStyle(
                        color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        hexToColor("#" + template_kNavigationFooterBarColor),
                    foregroundColor: nbtn4 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
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
                    "เหรียญ",
                    style: TextStyle(
                        color: kTextColor, fontWeight: FontWeight.bold),
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
