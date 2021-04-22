import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPage> {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey1 = GlobalKey<FormBuilderState>();
  bool active = false;
  SharedPreferences prefs;
  bool isLoading = false;
  String username = "";
  String password = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'MZReward': 'Register'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _login(Map<String, dynamic> values) async {
    setState(() {
      isLoading = true;
    });
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String playerId = status.subscriptionStatus.userId;
    print(playerId);
    username = values['username'];
    password = values['password'];
    //var url = 'https://mzreward.com/reward-api/public/api/Login_M';
    var url = pathAPI + "api/Login_M";
    print(url);
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          'username': values['username'],
          'password': values['password'],
          'member_noti': playerId
        }));
    if (response.statusCode == 200) {
      var token = convert.jsonDecode(response.body);
      //save to prefs
      // await prefs.setString('token', response.body);
      // var tokenString = prefs.getString('token');
      // var token1 = convert.jsonDecode(tokenString);
      // print(token1);
      //get profile

      //print(token);
      if (token['code'] == "200") {
        setState(() {
          isLoading = false;
        });
        var feedback = convert.jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedback['massage']),
            action: SnackBarAction(
              label: feedback['code'],
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } else if (token['code'] == "999") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(token['massage']),
            action: SnackBarAction(
              label: token['code'],
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );

        Navigator.pushNamed(context, '/pincode', arguments: {
          'username': username,
          'password': password,
          'token': token['data']
        });
      } else if (token['code'] == "400") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(token['massage']),
            action: SnackBarAction(
              label: token['code'],
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      } else {
        setState(() {
          isLoading = false;
        });
        var feedback = convert.jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedback['massage']),
            action: SnackBarAction(
              label: feedback['code'],
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);

        // Flushbar(
        //   title: '${feedback['massage']}',
        //   message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
        //   backgroundColor: Colors.redAccent,
        //   icon: Icon(
        //     Icons.error,
        //     size: 28.0,
        //     color: Colors.white,
        //   ),
        //   duration: Duration(seconds: 3),
        //   leftBarIndicatorColor: Colors.blue[300],
        // )..show(context);
        // Future.delayed(Duration(seconds: 3), () {
        //   Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
        // });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      var feedback = convert.jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedback['massage']),
          action: SnackBarAction(
            label: feedback['code'],
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map data = ModalRoute.of(context).settings.arguments;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //print(data);
    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                            "Login",
                            style: TextStyle(
                                color: Color(0xff64B6FF), fontSize: 40.0),
                          ),
                        ],
                      ),
                    ),
                    FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'username': username,
                        'member_username_game': '',
                        'board_shot_name': '',
                        'member_address': ''
                      },
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.all(10.0),
                            child: FormBuilderTextField(
                              attribute: 'username',
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'กรุณากรอก Username'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            // padding: EdgeInsets.all(10.0),
                            child: FormBuilderTextField(
                              attribute: 'password',
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'กรอกรหัสผ่าน'),
                                FormBuilderValidators.minLength(6,
                                    errorText:
                                        'รหัสผ่านของคุณต้องมี 6 ตัวอักกษรขึ้นไป'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_fbKey.currentState.saveAndValidate()) {
                                _login(_fbKey.currentState.value);
                                //print(_fbKey.currentState.value);
                              }
                            },
                            child: Container(
                              height: 50.0,
                              // margin:
                              //     EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff374ABE),
                                      Color(0xff64B6FF)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Center(
                                child: isLoading == true
                                    ? CircularProgressIndicator(
                                        //backgroundColor: Colors.blueAccent,
                                        )
                                    : Text(
                                        "เข้าสู่ระบบ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _launchInBrowser("https://mzreward.com/");
                                  },
                                  child: Text(
                                    "ยังมีไม่บัญชี ?",
                                    style: TextStyle(
                                      color: Color(0xff64B6FF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.pop(context);
                                //   },
                                //   child: Text(
                                //     "ลืมรหัสผ่าน",
                                //     style: TextStyle(
                                //       color: Color(0xff64B6FF),
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
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
    );
  }
}
