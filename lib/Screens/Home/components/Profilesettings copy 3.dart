import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  String username = "";
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
    var profile = prefs.getString('profile');
    var tokenprofile = convert.jsonDecode(profile);

    setState(() {
      username = tokenprofile['data']['username'];
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
          // 'Content-Type': 'application/json',
          'token': token['token']
        },
        body: ({
          'username': values['username'],
          'member_username_game': values['member_username_game'],
          'board_shot_name': values['board_shot_name'],
          'member_address': values['member_address'],
        }));
    if (response.statusCode == 200) {
      //var token = convert.jsonDecode(response.body);
      await prefs.setString('token', response.body);
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

  // _getComfirmUsername(Map<String, dynamic> values) async {
  //   //print(values);
  //   prefs = await SharedPreferences.getInstance();
  //   var tokenString = prefs.getString('token');
  //   var token = convert.jsonDecode(tokenString);

  //   setState(() {
  //     template_kNavigationBarColor = token['color']['color_1'];
  //     template_kNavigationFooterBarColor = token['color']['color_2'];
  //   });

  //   setState(() {
  //     isLoading = true;
  //   });
  //   var url = pathAPI + 'api/getComfirmUsername_M';
  //   var response = await http.post(url,
  //       headers: {
  //         //'Content-Type':'application/json',
  //         'token': token['token']
  //       },
  //       body: ({
  //         'username': values['username'],
  //         'member_username_game': values['member_username_game'],
  //         'board_shot_name': values['board_shot_name'],
  //         'member_address': values['member_address'],
  //       }));
  //   if (response.statusCode == 200) {
  //     //var token = convert.jsonDecode(response.body);
  //     await prefs.setString('token', response.body);
  //     final Map<String, dynamic> comfirm = convert.jsonDecode(response.body);
  //     if (comfirm['code'] == "200") {
  //       //print(comfirm['massage']);
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => dialogHome(
  //           comfirm['massage'],
  //           picSuccess,
  //           context,
  //         ),
  //       );
  //     } else {
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => errordialog(
  //           comfirm['massage'],
  //           checkData,
  //           picDenied,
  //           context,
  //         ),
  //       );
  //     }
  //   } else {
  //     // var comfirm = convert.jsonDecode(response.body);
  //     // print(comfirm['massage']);
  //     // print(response.statusCode);
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => errordialog(
  //         errorProfile,
  //         checkData,
  //         picDenied,
  //         context,
  //       ),
  //     );
  //   }
  // }

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
          'board_shot_name': values1['board_shot_name'],
          'member_address': values1['member_address']
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> profile = convert.jsonDecode(response.body);
      if (profile['code'] == "200") {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //print(data);
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ยืนยันสมาชิก",
                              style: TextStyle(
                                  color: Color(0xff64B6FF), fontSize: 40.0),
                            ),
                          ],
                        ),
                      ),
                      FormBuilder(
                        key: _fbKey1,
                        initialValue: {
                          'id': data['id'].toString(),
                          'member_name_th': data['member_name_th'],
                          'member_name_en': data['member_name_en'],
                          'member_email': data['member_email'],
                          'board_shot_name': data['board_name'],
                          'member_address': data['member_address']
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(0.0),
                              child: FormBuilderTextField(
                                attribute: 'member_name_th',
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "usernameth",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border:
                                      //InputBorder.none,
                                      OutlineInputBorder(),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'กรุณากรอก username'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              child: FormBuilderTextField(
                                attribute: 'member_name_en',
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "username",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'กรุณากรอก username'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              child: FormBuilderTextField(
                                attribute: 'member_email',
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Email address",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'กรุณากรอก email address'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              child: FormBuilderTextField(
                                attribute: 'board_shot_name',
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Board",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'กรุณากรอก ตัวย่อกระดาน'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //       bottom: BorderSide(
                              //           color: Colors
                              //               .grey[200])),
                              // ),
                              child: FormBuilderTextField(
                                attribute: 'member_address',
                                maxLines: 3,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "address",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'กรุณากรอก ที่อยู่'),
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
                                    if (_fbKey1.currentState
                                        .saveAndValidate()) {
                                      _getComfirmUsername(
                                          _fbKey1.currentState.value);
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
                                    borderRadius: BorderRadius.circular(4.0))),
                            SizedBox(
                              height: 40.0,
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
        ),
      ),
    );
  }
}
