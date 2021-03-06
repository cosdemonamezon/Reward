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
  Map<String, dynamic> group = {};
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;
  @override
  void initState() {
    super.initState();
    _getDetailGroupMember();
    _getlogGroupMember();
  }

  _getDetailGroupMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getDetailGroupMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> groupdata = convert.jsonDecode(response.body);
      if (groupdata['code'] == "200") {
        group = groupdata['data'];
        print(group);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            groupdata['massage'],
            picDenied,
            context,
          ),
        );
      }
    } else {
      final Map<String, dynamic> groupdata = convert.jsonDecode(response.body);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogHome(
          groupdata['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  _getlogGroupMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getlogGroupMember';

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> statusdata = convert.jsonDecode(response.body);
      if (statusdata['code'] == "200") {
        setState(() {
          data = statusdata['data'];
          setState(() {
            isLoading = false;
          });
        });
        //print(data);
      } else {
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
    } else {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: hexToColor("#" + template_kNavigationBarColor),
          elevation: 0,
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
          title: Text("ระดับสมาชิก"),
          bottom: TabBar(
            labelColor: hexToColor("#" +template_kNavigationFooterBarColor),
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ข้อมูล", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ประวัติ", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : group.length == 0
                    ? Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF01579B)),
                        ),
                      )
                    : Container(
                        height: 100,
                        child: Card(
                          ///clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 160,
                                          width: 160,
                                          child:
                                              group['group_member_pic'] != null
                                                  ? Image.network(
                                                      group['group_member_pic'],
                                                      fit: BoxFit.fill,
                                                      width: 1000)
                                                  : Image.asset(
                                                      "assets/images/nopic.png",
                                                      fit: BoxFit.fill),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "ชื่อระดับ:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_name'] != null
                                                ? Text(
                                                    group['group_member_name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "ประเภท:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_type'] != null
                                                ? Text(
                                                    group['group_member_type'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "ชื่อกระดาน:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['board_name'] != null
                                                ? Text(group['board_name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "คะแนนจากการชวนเพื่อน:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_point_invite'] !=
                                                    null
                                                ? Text(
                                                    group['group_member_point_invite']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "คะแนนจากการแชร์:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_point_shere'] !=
                                                    null
                                                ? Text(
                                                    group['group_member_point_shere']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "คะแนนจากการสมัคร:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['point_register'] != null
                                                ? Text(
                                                    group['point_register']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "คะแนนจากการเล่นต่อเนื่อง:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_point_seven_day'] !=
                                                    null
                                                ? Text(
                                                    group['group_member_point_seven_day']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "วันที่เริ่ม:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_date_start'] !=
                                                    null
                                                ? Text(
                                                    group['group_member_date_start']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          children: [
                                            Text(
                                              "วันที่สิ้นสุด:  ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            group['group_member_date_end'] !=
                                                    null
                                                ? Text(
                                                    group['group_member_date_end']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0))
                                                : Text("ไม่มีข้อมูล",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : data.length == 0
                    ? Center(
                        child: Text(
                          "ไม่พบข้อมูล",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF01579B)),
                        ),
                      )
                    : Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    elevation: 8.0,
                                    //color: Colors.grey[800],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: data[index]['pic'] !=
                                                          null
                                                      ? Image.network(
                                                          data[index]['pic'],
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.network(
                                                          'https://picsum.photos/400/200',
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [                                                  
                                                  Text(
                                                    'ชื่อกลุ่ม : ${data[index]['old_group']}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.5, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'อัปเดตโดย : ${data[index]['updated_by']}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.5, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'ประเภท : ${data[index]['group_member_type']}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.5, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${data[index]['createdDate']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.5),
                                              ),
                                              SizedBox(width: 5,),
                                              Text(
                                                '${data[index]['createdTime']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.5),
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
                            itemCount: data.length),
                      ),
          ],
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
                      foregroundColor:
                          nbtn1 == true ? Colors.red : Colors.white,
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
                          launch(('tel://${data2['board_phone_1']}'));
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
                      foregroundColor:
                          nbtn2 == true ? Colors.red : Colors.white,
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
                            'member_point': data2['member_point'],
                            'board_phone_1': data2['board_phone_1'],
                            'total_noti': data2['total_noti'],
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
                          child: data2['total_noti'] == null
                              ? SizedBox(
                                  height: 2.0,
                                )
                              : data2['total_noti'] == 0
                                  ? SizedBox(
                                      height: 2.0,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 10,
                                      child: Text(
                                        data2['total_noti'].toString(),
                                        style: TextStyle(
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                    Text(
                      "แจ้งเตือน",
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
                      foregroundColor:
                          nbtn4 == true ? Colors.red : Colors.white,
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
                            'member_point': data2['member_point'],
                            'board_phone_1': data2['board_phone_1'],
                            'total_noti': data2['total_noti'],
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
      ),
    );
  }
}
