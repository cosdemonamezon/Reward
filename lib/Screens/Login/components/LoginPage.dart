import 'package:Reward/Screens/Home/HomeScreen.dart';
import 'package:Reward/constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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
    var url = 'http://103.74.253.96/reward-api/public/api/Login_M';
    var response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: convert.jsonEncode({
        'username': values['username'],
        'password': values['password']
      })
    );
    if (response.statusCode == 200){
      var token = convert.jsonDecode(response.body);
      //save to prefs
      await prefs.setString('token', response.body);
      // var tokenString = prefs.getString('token');
      // var token1 = convert.jsonDecode(tokenString);
      // print(token1);
      //get profile

      
      //print(token);
      if(token['code'] == "200"){
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
          Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        });
        //Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      }
      else{
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
      
      
    }
    else {
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/home.jpg", fit: BoxFit.cover,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.7),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.0,),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Login", style: TextStyle(color: kTextColor, fontSize: 40.0),),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FormBuilder(
                              key: _fbKey,
                              initialValue: {
                                'username': '',
                                'password': '',
                              },
                              
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(
                                        color: Color.fromRGBO(255, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      )],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                          ),
                                          child: FormBuilderTextField(
                                            attribute: 'username',
                                            decoration: InputDecoration(
                                              hintText: "Username",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                            validators: [
                                              FormBuilderValidators.required(errorText: 'กรุณากรอกชื่อผู้ใช้')
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
                                              hintText: "Password",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                            validators: [
                                              FormBuilderValidators.required(errorText: 'กรอกรหัสผ่าน'),
                                              FormBuilderValidators.minLength(5, errorText: 'รหัสผ่านของคุณต้องมี 5 ตัวอักกษรขึ้นไป'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25.0,),
                                  GestureDetector(
                                    onTap: (){
                                      if (_fbKey.currentState.saveAndValidate()) {
                                        _login(_fbKey.currentState.value);
                                        //print(_fbKey.currentState.value);
                                      }
                                      
                                    },
                                    child: Container(
                                      height: 50.0,
                                      margin: EdgeInsets.symmetric(horizontal: 60),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.orange[900],
                                      ),
                                      child: Center(
                                        child: isLoading == true ?
                                        CircularProgressIndicator(
                                          //backgroundColor: Colors.blueAccent,
                                        )
                                        : Text(
                                          "Login", 
                                          style: TextStyle(
                                            color: Colors.white, 
                                            fontSize: 20, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){},
                                        child: Text(
                                          "Lost your password?",
                                          style: TextStyle(
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Back to page", 
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
    );
  }
}