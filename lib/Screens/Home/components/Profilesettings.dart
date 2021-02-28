import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profilesettings extends StatefulWidget {
  Profilesettings({Key key}) : super(key: key);

  @override
  _ProfilesettingsState createState() => _ProfilesettingsState();
}

class _ProfilesettingsState extends State<Profilesettings> {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey1 = GlobalKey<FormBuilderState>();
  bool active = false;
  SharedPreferences prefs;
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getActive();
    _getColor();
  }

  _getActive() {
    active = true;
    //initState();
  }

  _getColor() async {
    //print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });
  }

  _getComfirmUsername(Map<String, dynamic> values) async {
    //print(values);
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
    var url = pathAPI + 'api/getComfirmUsername_M';
    var response = await http.post(url,
        headers: {
          //'Content-Type':'application/json',
          'token': token['token']
        },
        body: ({
          'username': values['username'],
          'member_username_game': values['member_username_game'],
          'board_shot_name': values['board_shot_name'],
          'member_address': values['member_address'],
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> comfirm = convert.jsonDecode(response.body);
      if (comfirm['code'] == "200") {
        //print(comfirm['massage']);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            comfirm['massage'],
            picSuccess,
            context,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            comfirm['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      }
    } else {
      // var comfirm = convert.jsonDecode(response.body);
      // print(comfirm['massage']);
      // print(response.statusCode);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => errordialog(
          errorProfile,
          checkData,
          picDenied,
          context,
        ),
      );
    }
  }

  _editMember(Map<String, dynamic> values1) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //String s = values1['id'];
    //int id = int.parse(s);
    //print(values1);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/edit_Member';
    var response = await http.post(url,
        headers: {
          //'Content-Type':'application/json',
          'token': token['token']
        },
        body: ({
          'member_id': values1['id'],
          //'member_id': id,
          'member_name_th': values1['member_name_th'],
          'member_name_en': values1['member_name_en'],
          'member_email': values1['member_email'],
          'member_address': values1['member_address']
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> profile = convert.jsonDecode(response.body);
      if (profile['code'] == "200") {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        // Flushbar(
        //   title: '${profile['massage']}',
        //   //message: "ขอบคุณ",
        //   icon: Icon(
        //     Icons.info_outline,
        //     size: 28.0,
        //     color: Colors.blue[300],
        //   ),
        //   duration: Duration(seconds: 3),
        //   leftBarIndicatorColor: Colors.blue[300],
        // ).show(context);
        // void showTopSnackBar(BuildContext context,) => Flushbar(
        //   icon: Icon(Icons.info_outline, size: 32, color: Colors.white,),
        //   shouldIconPulse: false,
        //   title: profile['massage'],
        //   duration: Duration(seconds: 3),
        //   flushbarPosition: FlushbarPosition.TOP,
        // )..show(context);

        //showTopSnackBar(context);
        // Future.delayed(Duration(seconds: 3), () {
        //   //Navigator.pop(context);
        //   Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        // });

      } else if (profile['code'] == "400") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            errorProfile,
            picDenied,
            context,
          ),
        );
      } else if (profile['code'] == "500") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            profile['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            headtitle,
            picDenied,
            context,
          ),
        );
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          headtitle,
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return Scaffold(
      backgroundColor: hexToColor("#" + template_kNavigationBarColor),
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
        title: Text("Profile"),
      ),
      body: data.length == 0
          ? Center(
              child: Text(
                "ไม่พบข้อมูล",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                data['member_activate'] == "Yes"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "ตั้งค่าโปรไฟล์",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: isLoading == true
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.redAccent,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.green),
                                      //strokeWidth: 19,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30)),
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Colors.white, Colors.white,
                                                //Color.fromRGBO(0, 41, 102, 1),
                                              ])),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    FormBuilder(
                                                      key: _fbKey1,
                                                      initialValue: {
                                                        'id': data['id']
                                                            .toString(),
                                                        'member_name_th': data[
                                                            'member_name_th'],
                                                        'member_name_en': data[
                                                            'member_name_en'],
                                                        'member_email': data[
                                                            'member_email'],
                                                        'member_address': data[
                                                            'member_address']
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child:
                                                                FormBuilderTextField(
                                                              attribute:
                                                                  'member_name_th',
                                                              autofocus: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "usernameth",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                border:
                                                                    //InputBorder.none,
                                                                    OutlineInputBorder(),
                                                              ),
                                                              validators: [
                                                                FormBuilderValidators
                                                                    .required(
                                                                        errorText:
                                                                            'กรุณากรอก username'),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child:
                                                                FormBuilderTextField(
                                                              attribute:
                                                                  'member_name_en',
                                                              autofocus: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "username",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              validators: [
                                                                FormBuilderValidators
                                                                    .required(
                                                                        errorText:
                                                                            'กรุณากรอก username'),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child:
                                                                FormBuilderTextField(
                                                              attribute:
                                                                  'member_email',
                                                              autofocus: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Email address",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              validators: [
                                                                FormBuilderValidators
                                                                    .required(
                                                                        errorText:
                                                                            'กรุณากรอก email address'),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            // decoration: BoxDecoration(
                                                            //   border: Border(
                                                            //       bottom: BorderSide(
                                                            //           color: Colors
                                                            //               .grey[200])),
                                                            // ),
                                                            child:
                                                                FormBuilderTextField(
                                                              attribute:
                                                                  'member_address',
                                                              maxLines: 5,
                                                              autofocus: false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "address",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              validators: [
                                                                FormBuilderValidators
                                                                    .required(
                                                                        errorText:
                                                                            'กรุณากรอก ที่อยู่'),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  if (_fbKey1
                                                                      .currentState
                                                                      .saveAndValidate()) {
                                                                    _editMember(_fbKey1
                                                                        .currentState
                                                                        .value);
                                                                    // setState((){
                                                                    //   isLoading = true;
                                                                    // });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      //isLoading = true;
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "บันทึก",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          hexToColor("#" +
                                                                              template_kNavigationFooterBarColor),
                                                                          hexToColor("#" +
                                                                              template_kNavigationBarColor)
                                                                        ],
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0))),
                                                          SizedBox(
                                                            height: 40.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "ยืนยัน สมาชิก",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.white, Colors.white,
                                        //Color.fromRGBO(0, 41, 102, 1),
                                      ])),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      FormBuilder(
                                        key: _fbKey,
                                        initialValue: {
                                          'username': '',
                                          'member_username_game': '',
                                          'board_shot_name': '',
                                          'member_address':
                                              data['member_address']
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: FormBuilderTextField(
                                                attribute: 'username',
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText: "Username",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                                validators: [
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'กรุณากรอก username'),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: FormBuilderTextField(
                                                attribute:
                                                    'member_username_game',
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText: "Username Game",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                                validators: [
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'กรุณากรอก user game'),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: FormBuilderTextField(
                                                attribute: 'board_shot_name',
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText: "Board",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                                validators: [
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'กรุณากรอก ตัวย่อกระดาน'),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: FormBuilderTextField(
                                                attribute: 'member_address',
                                                maxLines: 5,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText: "ที่อยู่",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                                validators: [
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'กรุณากรอก ที่อยู่'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                                width: double.infinity,
                                                child: FlatButton(
                                                  onPressed: () {
                                                    if (_fbKey.currentState
                                                        .saveAndValidate()) {
                                                      _getComfirmUsername(_fbKey
                                                          .currentState.value);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        //isLoading = true;
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    "บันทึก",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        hexToColor("#" +
                                                            template_kNavigationFooterBarColor),
                                                        hexToColor("#" +
                                                            template_kNavigationBarColor)
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                    backgroundColor: nbtn1 == true ?
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
}
