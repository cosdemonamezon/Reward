import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:Reward/constants.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NotiScreen extends StatefulWidget {
  NotiScreen({Key key}) : super(key: key);

  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  Map<String, dynamic> readnotidata = {};
  Map<String, dynamic> numberNoti = {};
  Map<String, dynamic> profiledata = {};
  String notiPage = "notiPage";
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotiMember();
  }

  _getNotiMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var profile = prefs.getString('profile');
    var tokenprofile = convert.jsonDecode(profile);

    setState(() {
      profiledata = tokenprofile['data'];
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    prefsNoti = await SharedPreferences.getInstance();
    var notiString = prefsNoti.getString('notification');
    var noti = convert.jsonDecode(notiString);
    //print(noti['data']);
    //print(token['token']);
    //print(token['member_id']);
    setState(() {
      isLoading = true;
      numberNoti = noti['data'];
    });
    var url = pathAPI + 'api/getNotiMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));
    if (response.statusCode == 200) {
      //print(response.statusCode);
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);
      //print(notinumber);
      if (notinumber['code'] == "200") {
        setState(() {
          notidata = notinumber['data'];
          setState(() {
            isLoading = false;
          });
        });

        //print(notidata.length);
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
    } else {
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          notinumber['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  _readNotiMember(var id) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(id);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/readNotiMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert
            .jsonEncode({'member_id': token['member_id'], 'noti_log_id': id}));

    if (response.statusCode == 200) {
      _getHomePage();
      final Map<String, dynamic> notiread = convert.jsonDecode(response.body);
      if (notiread['code'] == "200") {
        //print(notiread);
        setState(() {
          //readnotidata = notiread['data'];
          setState(() {
            isLoading = false;
          });
        });
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
    } else {
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          notinumber['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  _getHomePage() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    bool isTokenExpired = JwtDecoder.isExpired(token['token']);

    try {
      if (!isTokenExpired) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginScreen', (Route<dynamic> route) => false);
      } else {
        setState(() {
          isLoading = true;
        });
        var url = pathAPI + 'api/getHome_M';
        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'token': token['token']
            },
            body: convert.jsonEncode({'member_id': token['member_id']}));
        if (response.statusCode == 200) {
          var notification = convert.jsonDecode(response.body);
          await prefsNoti.setString('notification', response.body);
          setState(() {
            isLoading = true;
            numberNoti = notification['data'];
          });
        } else {
          return false;
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
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
        title: Text("แจ้งเตือน"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notidata.length == 0
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
              : Container(
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: notidata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              var url = notidata[index]['url'];
                              var noti_log_id = notidata[index]['id'];
                              if (notidata[index]['noti_type'] == "News") {
                                //launch((url));
                                _readNotiMember(noti_log_id);
                                Navigator.pushNamed(context, "/notidetail",
                                    arguments: {
                                      'member_point': data['member_point'],
                                      'board_phone_1': data['board_phone_1'],
                                      'total_noti': numberNoti['total_noti']-1,
                                      'title': notidata[index]['title'],
                                      'description': notidata[index]['description'],
                                      'pic': notidata[index]['pic'],
                                      'created_at': notidata[index]['created_at'],
                                      'url': notidata[index]['url'],                                      
                                    });
                              } else if (notidata[index]['noti_type'] =="Point") {
                                _readNotiMember(noti_log_id);
                                Navigator.pushNamed(context, "/point",
                                    arguments: {
                                      'member_point': data['member_point'],
                                      'board_phone_1': data['board_phone_1'],
                                      'total_noti': numberNoti['total_noti']-1,
                                    });
                              } else if (notidata[index]['noti_type'] ==
                                  "Reward") {
                                    _readNotiMember(noti_log_id);
                                Navigator.pushNamed(context, "/slip",
                                    arguments: {
                                      'date_appove': notidata[index]['date_appove'],
                                      'created_at': notidata[index]['trans_at'],
                                      'appove_status': notidata[index]['appove_status'],
                                      'appove_by': notidata[index]['appove_by'],
                                      'reward_slip': notidata[index]['reward_slip'],
                                      'reason_cancel': notidata[index]['reason_cancel'],
                                      'member_id': profiledata['member_id'],
                                      'username': profiledata['username'],
                                      'member_name_en': profiledata['member_name_en'],
                                      'member_name_th': profiledata['member_name_th'],
                                      'member_email': profiledata['member_email'],
                                      'member_phone': profiledata['member_phone'],
                                      'notiPage': notiPage,
                                      'member_point': data['member_point'],
                                      'board_phone_1': data['board_phone_1'],
                                      'total_noti': numberNoti['total_noti']-1,
                                    });
                              } else {
                                //print("ไม่มีลิ้ง");

                              }
                              //launch((url));
                            },
                            child: Card(
                              color: notidata[index]["noti_log_read"] == 0
                                  ? Colors.blue[50]
                                  : Colors.white,
                              elevation: 8.0,
                              child: ListTile(
                                leading: notidata[index]["pic"] == null
                                    ? Icon(
                                        Icons.notifications_active,
                                        size: 40,
                                      )
                                    : Container(
                                        width: 70.0,
                                        height: 50.0,
                                        child: Image.network(
                                          notidata[index]['pic'],
                                          fit: BoxFit.fill,
                                        )),
                                title: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: notidata[index]['title'].length >= 30
                                      ? Text(
                                          "${notidata[index]['title'].substring(0, 30)} ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400))
                                      : Text(notidata[index]['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400)),
                                ),
                                subtitle: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: notidata[index]['description']
                                                  .length >=
                                              50
                                          ? Text(
                                              "${notidata[index]['description'].substring(0, 50)} ...",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400))
                                          : Text(notidata[index]['description'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(notidata[index]['createdDate']),
                                        SizedBox(width: 10,),
                                        Text(notidata[index]['createdTime']),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        );
                      }),
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
                        launch(('tel://${data['board_phone_1']}'));
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
                    backgroundColor:nbtn2 == true ?
                       Colors.white54  : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        backgroundColor: nbtn3 == true ?
                       Colors.white54  : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        child: numberNoti['total_noti'] == null
                            ? SizedBox(
                                height: 2.0,
                              )
                            : numberNoti['total_noti'] == 0
                                ? SizedBox(
                                    height: 2.0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 10,
                                    child: Text(
                                      numberNoti['total_noti'].toString(),
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
                    backgroundColor:nbtn4 == true ?
                       Colors.white54  : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Coin();
                          }),
                        );
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
