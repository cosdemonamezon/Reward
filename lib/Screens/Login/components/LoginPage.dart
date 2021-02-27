import 'package:Reward/Screens/Home/HomeScreen.dart';
import 'package:Reward/constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:Reward/Screens/Login/components/Coinofline.dart';
import 'package:Reward/Screens/Login/components/Helpofline.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autovalidate = false;
  bool isLoading = false;
  SharedPreferences prefs;
  Map<String, dynamic> data = {};
  String username = '';
  String password = '';

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
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
      await prefs.setString('token', response.body);
      // var tokenString = prefs.getString('token');
      // var token1 = convert.jsonDecode(tokenString);
      // print(token1);
      //get profile

      //print(token);
      if (token['code'] == "200") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
        });
        //Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      } else if (token['code'] == "999") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        ).show(context);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushNamed(context, '/pincode', arguments: {
            'username': username,
            'password': password,
            'token': token['data']
          });
        });
      } else if (token['code'] == "400") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['massage']}',
          message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
          backgroundColor: Colors.redAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        // Future.delayed(Duration(seconds: 3), () {
        //   Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
        // });
      }
    } else {
      // setState(() {
      //   isLoading = false;
      // });
      //print(response.body);
      var feedback = convert.jsonDecode(response.body);
      Flushbar(
        title: '${feedback['message']}',
        message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
        backgroundColor: Colors.redAccent,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/home.jpg",
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            reverse: true, // this is new
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              margin: EdgeInsets.only(top: height * 0.67, bottom: 30),
              color: Color(0xff070d3f),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'กรอกชื่อผู้ใช้หรืออีเมล': '',
                        'กรอกรหัสผ่าน': '',
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: FormBuilderTextField(
                                    attribute: 'username',
                                    decoration: InputDecoration(
                                      hintText: "ชื่อผู้เข้าใช้",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validators: [
                                      FormBuilderValidators.required(
                                          errorText: 'กรุณากรอกชื่อผู้ใช้')
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  // decoration: BoxDecoration(
                                  //   border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  // ),
                                  child: FormBuilderTextField(
                                    attribute: 'password',
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "รหัสผ่าน",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
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
                                  borderRadius: BorderRadius.circular(10.0)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "ลืมรหัสผ่าน?",
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "ย้อนกลับ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      // this is new
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
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
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => dialogAlert(
                            aertLogin, picDenied, context,
                          ),
                        ); 
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
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Helpofline();}
                          ),
                        );
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
                  CircleAvatar(
                    backgroundImage: AssetImage(pathicon3),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => dialogAlert(
                            aertLogin, picDenied, context,
                          ),
                        ); 
                      },
                    ),
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
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Coineofline();}
                          ),
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
