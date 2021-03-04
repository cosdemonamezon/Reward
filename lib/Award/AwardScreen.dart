import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'dart:convert' show utf8, base64;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AwardScreen extends StatefulWidget {
  AwardScreen({Key key}) : super(key: key);

  @override
  _AwardScreenState createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> shareLink = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;
  SharedPreferences prefsNoti;
  Map<String, dynamic> numberNoti = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShareLinkReward();
  }

  _getShareLinkReward() async {
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

    var url = pathAPI + 'api/getShareLinkReward';
    setState(() {
      isLoading = true;
      numberNoti = noti['data'];
    });
    if (numberNoti['member_activate'] == "No") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertConfirmUsername(
          settitle,
          comfirmUse,
          picWanning,
          context,
        ),
      );
    } else {
      var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> shareLinkdata =
            convert.jsonDecode(response.body);
        if (shareLinkdata['code'] == "200") {
          print(shareLinkdata);
          setState(() {
            shareLink = shareLinkdata['data'];
            setState(() {
              isLoading = false;
            });
            //print(shareLink);
            //print(shareLink['pic']);
          });
        } else {
          setState(() {
            isLoading = false;
          });
          String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => dialogHome(
              shareLinkdata['massage'],
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
    
  }

  _shereLinkReward(var shere_reward_id) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI + 'api/shereLinkReward';
    // print(shere_reward_id);
    // print(token['token']);
    // print(token['member_id']);
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({
          'member_id': token['member_id'],
          'shere_reward_id': shere_reward_id
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> sharedata = convert.jsonDecode(response.body);
      if (sharedata['code'] == "200") {
        //print(sharedata['massage']);
        Alert(
            context: context,
            type: AlertType.success,
            title: sharedata['massage'],
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (Route<dynamic> route) => false);
                },
              ),
            ]).show();
      } else if (sharedata['code'] == "400") {
        //print(sharedata['massage']);
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            sharedata['massage'],
            picDenied,
            context,
          ),
        );
      } else if (sharedata['code'] == "500") {
        //print(sharedata['massage']);
        showDialog(
          context: context,
          builder: (context) => dialogHome(
            sharedata['massage'],
            picDenied,
            context,
          ),
        );
      } else {
        //print(sharedata['massage']);
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            sharedata['massage'],
            picDenied,
            context,
          ),
        );
      }
    } else {
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        context: context,
        builder: (context) => dialogDenied(
          title,
          picDenied,
          context,
        ),
      );
    }
  }

  _getlink(int id, int total_noti, String board_phone_1) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    String encoded = base64Url.encode(utf8.encode(
        token['member_id'].toString() +
            "&&" +
            id.toString() +
            "&&" +
            token['token']));
    String url1 = "https://mzreward.com/share_reward/?" + encoded;

    // Navigator.pushNamed(context, '/webview', arguments: {
    //   'id': data['id'],
    //   'board_phone_1': board_phone_1,
    //   'total_noti': total_noti,
    //   'url': url1
    // });

    launch(url1);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
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
        title: Text("รางวัล"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : shareLink.length == 0
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
              : SingleChildScrollView(
                child: Column(
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200.0,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: shareLink['pic'] != null
                                        ? Image.network(
                                            shareLink['pic'],
                                            fit: BoxFit.fill,
                                          )
                                        : Ink.image(
                                            image: NetworkImage(
                                                'https://picsum.photos/400/200'),
                                            fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 15,
                                    child: Icon(
                                      Icons.share,
                                      size: 40.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  
                                  Text(
                                    shareLink['title'] == null
                                        ? "ไม่มีข้อมูล"
                                        : shareLink['title'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    shareLink['description'] == null
                                        ? "ไม่มีข้อมูล"
                                        : shareLink['description'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "เริ่ม", style: TextStyle(
                                            fontSize: 15.0, color: Colors.green, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "${shareLink['date_start']}", style: TextStyle(
                                            fontSize: 15.0, color: Colors.green, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          "ถึง", style: TextStyle(
                                            fontSize: 15.0, color: Colors.green, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          "${shareLink['date_stop']}", style: TextStyle(
                                            fontSize: 15.0, color: Colors.green, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          width: double.infinity,
                          child: FlatButton.icon(
                            onPressed: () async{
                              if (shareLink['date_exp'] == "Yes") {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => errorPopup(
                                    dateexp,
                                    picWanning,
                                    context,
                                  ),
                                );
                              } else if (shareLink['shere_status'] == "Yes") {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => errorPopup(
                                    sharestatus,
                                    picWanning,
                                    context,
                                  ),
                                );
                              } else if (shareLink['date_exp'] == "Yes" &&
                                  shareLink['shere_status'] == "Yes") {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => errorPopup(
                                    statusdateexp,
                                    picWanning,
                                    context,
                                  ),
                                );
                              } else {
                                int id = shareLink['id'];
                                String board_phone_1 = data['board_phone_1'];
                                int total_noti = data['total_noti'];
                                _getlink(id, total_noti, board_phone_1);
                              }                    
                            },
                            label: Text(
                              "Click Share Facebook",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20),
                            ),
                            icon: Icon(Icons.share, color:Colors.white, size: 40,),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                hexToColor("#" +
                                  template_kNavigationFooterBarColor),
                                hexToColor("#" +
                                  template_kNavigationBarColor)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10.0))),
                      ),

                      SizedBox(
                        height: 30,
                      ),
      
                    ],
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
  alertConfirmUsername(
    String title,
    String subtitle,
    String img,
    context,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  comfirmUse,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profilesetting',
                              arguments: {
                                'id': data['id'],
                                'member_name_th': data['member_name_th'],
                                'member_name_en': data['member_name_en'],
                                'member_email': data['member_email'],
                                'member_address': data['member_address'],
                                'member_activate': data['member_activate'],
                                'board_phone_1': data['board_phone_1'],
                                'total_noti': data['total_noti'],
                              });
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFFD50000),
                        child: Text('ยืนยันสมาชิก',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/home',
                              (Route<dynamic> route) => false);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFF01579B),
                        child: Text('ไปหน้าหลัก',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset(img)),
            ),
          ),
        ],
      ),
    );
  }
}
