import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Reward/constants.dart';

class DetailReward extends StatefulWidget {
  DetailReward({Key key}) : super(key: key);

  @override
  _DetailRewardState createState() => _DetailRewardState();
}

class _DetailRewardState extends State<DetailReward> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String confrim_address_status = 'Yes';
  SharedPreferences prefs;
  bool isLoading = false;
  //List<dynamic> detailreward = [];

  _transferReward(Map<String, dynamic> data) async {
    print(data);
    print(data['member_id']);
    print(data['id']);
    print(confrim_address_status);
    print(data['member_point']);

    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/transferReward';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({
          'member_id': data['member_id'],
          'reward_id': data['id'],
          'confrim_address_status': confrim_address_status,
          'member_point': data['member_point']
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> detailreward =
          convert.jsonDecode(response.body);
      //print(detailreward);
      if (detailreward['code'] == "200") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            detailreward['massage'],
            picSuccess,
            context,
          ),
        );
        
      } else if (detailreward['code'] == "400") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      } else if (detailreward['code'] == "500") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      } else if (detailreward['code'] == "600") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      } else if (detailreward['code'] == "700") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      } else if (detailreward['code'] == "800") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
      }
    } else {
      final Map<String, dynamic> detailreward =
          convert.jsonDecode(response.body);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            detailreward['massage'],
            picDenied,
            context,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomButton() {
      return Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  color: Colors.black,
                  onPressed: () {},
                  child: Text(
                    "Buy  Now".toUpperCase(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget Property(String member_point, String point) {
      return Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("คะแนนของคุณ"),
                Text(
                  member_point,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F3E)),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text("คะแนนที่ใช้"),
                Text(
                  point,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F3E)),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget section(String desc, String point) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [SizedBox(height: 10), Property(desc, point)],
        ),
      );
    }

    property(String desc, String point) {}

    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print(data);
    //print(confrim_address_status);
    bool pointStatus = true;

    if (data['transfer_status'] == true &&
        data['group_status'] == true &&
        data['qty_status'] == true) {
      setState(() {
        pointStatus = true;
        //pointStatus = false;
      });
    } else {
      setState(() {
        pointStatus = false;
        // pointStatus = true;
      });
    }
    //print(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Reward"),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "โปรโมชั่นแลกของวันนี้",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text("รายละเอียด"),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${data['title']}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(),
                child: Image.network(
                  data['pic'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${data['description']}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text("เงื่อนไข"),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ]),
              section(
                  data['member_point'].toString(), data['point'].toString()),

              Padding(
                padding:
                    EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 50,
                    //     child: FlatButton(
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(18)),
                    //       color: Colors.black,
                    //       onPressed: () {},
                    //       child: Text(
                    //         "Buy  Now".toUpperCase(),
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 50.0,
                    //   width: 120.0,
                    //   decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                    //         begin: Alignment.topCenter,
                    //         end: Alignment.bottomCenter,
                    //       ),
                    //       borderRadius: BorderRadius.circular(10.0)),
                    //   child: Center(
                    //     child: Text(
                    //       "โอน Point",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 16.0,
                    //           color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: pointStatus == true
                          ? Container(
                              child: FlatButton(
                                onPressed: () {
                                  _transferReward(data);
                                },
                                child: Text(
                                  "แลกรางวัล",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff374ABE),
                                      Color(0xff64B6FF)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)))
                          : Container(
                              child: FlatButton(
                                onPressed: null,
                                child: Text(
                                  "คะแนนไม่พอ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff374ABE),
                                      Color(0xff64B6FF)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0))),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 50,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Color(0xff64B6FF),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.link,
                          color: Color(0xff64B6FF),
                        ),
                        onPressed: () {
                          var url = data['url'];
                          launch((url));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: pointStatus == true
              //   ? SizedBox(height: 5.0,)
              //   : Text(
              //     "แต้มไม่พอ",
              //     style: TextStyle(
              //       color: Colors.red,
              //       fontWeight: FontWeight.bold
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //     onTap: () {
              //       var url = data['url'];
              //       launch((url));
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Text("LINK ==> ${data['url']}"),
              //     )),
            ],
          ),
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
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 15.0, bottom: 10.0),
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
