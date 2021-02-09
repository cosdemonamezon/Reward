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
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey1 = GlobalKey<FormBuilderState>();
  bool active = false;
  SharedPreferences prefs;
  bool isLoading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  

  @override
  void initState(){
    super.initState();
    _getActive();
  }

  _getActive(){
    active = true;
    //initState();
  }

  _getComfirmUsername(Map<String, dynamic> values) async{
    print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getComfirmUsername_M';
    var response = await http.post(
      url,
      headers: {
        //'Content-Type':'application/json',
        'token': token['token']
      },
      body: ({
        'username': values['username'],
        'member_username_game': values['member_username_game'],
        'board_shot_name': values['board_shot_name'],
        'member_address': values['member_address'],
      }) 
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> comfirm = convert.jsonDecode(response.body);
      if (comfirm['code'] == "200") {
        print(comfirm['massage']);
        Alert(
          context: context,
          type: AlertType.info,
          title: "ท่านต้องการยืนยันข้อมูลสามาชิก",
          buttons: [
            DialogButton(
              child: Text(
                "ยกเลิก",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            ),
          ],
        ).show();
      } else {
      }
    }else{
      var comfirm = convert.jsonDecode(response.body);
      print(comfirm['massage']);
      print(response.statusCode);
    }
  }

  _editMember(Map<String, dynamic> values1) async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //String s = values1['id'];
    //int id = int.parse(s);
    print(values1);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/edit_Member';
    var response = await http.post(
      url,
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
      }) 
    );

    if (response.statusCode == 200){
      final Map<String, dynamic> profile = convert.jsonDecode(response.body);
      if(profile['code'] == "200"){
        Flushbar(
          title: '${profile['massage']}',
          message: "ขอบคุณ",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.green[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        Future.delayed(Duration(seconds: 3), () {
          //Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        });
      }else{
        Flushbar(
          title: '${profile['code']}',
          message: "ไม่สำร็จ ระบบขัดข้อง กรุณาตรวจสอบอีกครั้ง",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red[300],
        )..show(context);
      }
    }else{
      var profile = convert.jsonDecode(response.body);
      Flushbar(
        title: '',
        message: "ไม่สำร็จ มีข้อผิดพลาด",
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red[300],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red[300],
      )..show(context);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    print(data);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/home.jpg", fit: BoxFit.cover,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.7),
          ),
          data['member_activate'] == "Yes" ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0,),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Profile Setting", style: TextStyle(color: kTextColor, fontSize: 40.0),),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          FormBuilder(
                            key: _fbKey1,
                            initialValue: {
                              'id': data['id'].toString(),
                              'member_name_th': data['member_name_th'],
                              'member_name_en': data['member_name_en'],
                              'member_email': data['member_email'],
                              'member_address': data['member_address']
                            },
                            child: isLoading == true ? CircularProgressIndicator(
                              backgroundColor: Colors.redAccent,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                              strokeWidth: 19,
                            )
                            :Container(
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
                                      attribute: 'member_name_th',
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: "usernameth",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก username'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'member_name_en',
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: "username",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก username'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'member_email',
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: "Email address",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก email address'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'member_address',
                                      maxLines: 5,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: "address",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก ที่อยู่'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamedAndRemoveUntil(
                                            context, '/home', (route) => false
                                          );
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff515151),
                                                Color(0xffa3a3a3)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "ยกเลิก",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          if (_fbKey1.currentState.saveAndValidate()){
                                            _editMember(_fbKey1.currentState.value);
                                            // setState((){
                                            //   isLoading = true;
                                            // });
                                          }else {
                                            setState((){
                                              //isLoading = true;
                                            });
                                          }    
                                          //_editMember();
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff374ABE),
                                                Color(0xff64B6FF)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "บันทึก",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
          )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0,),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("ยืนยัน สมาชิก", style: TextStyle(color: kTextColor, fontSize: 40.0),),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Expanded(
                child: Container(
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
                              'member_address': data['member_address']
                            },
                            child: Container(
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
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก username'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'member_username_game',
                                      decoration: InputDecoration(
                                        hintText: "Username Game",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก user game'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'board_shot_name',
                                      decoration: InputDecoration(
                                        hintText: "Board",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validators: [
                                        FormBuilderValidators.required(errorText: 'กรุณากรอก ตัวย่อกระดาน'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'member_address',
                                      maxLines: 5,
                                      autofocus: false,
                                      decoration: InputDecoration(                                        
                                        hintText: "ที่อยู่",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 25.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamedAndRemoveUntil(
                                            context, '/home', (route) => false
                                          );
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff515151),
                                                Color(0xffa3a3a3)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                            
                                          ),
                                          child: Center(
                                            child: Text(
                                              "ยกเลิก",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          // //_getActive();
                                          // setState(() {
                                          //   active = false;
                                          // });
                                          if (_fbKey.currentState.saveAndValidate()){
                                            _getComfirmUsername(_fbKey.currentState.value);
                                            setState((){
                                              isLoading = true;
                                            });
                                          }else {
                                            setState((){
                                              //isLoading = true;
                                            });
                                          }                                          
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff374ABE),
                                                Color(0xff64B6FF)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                            
                                          ),
                                          child: Center(
                                            child: Text(
                                              "บันทึก",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0,),
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
          padding: const EdgeInsets.only(left:30.0, right: 30.0, top: 15.0, bottom: 10.0),
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
                      onTap: (){
                        //launch(('tel://${item.mobile_no}'));
                        //launch(('tel://0922568260'));
                        launch(('tel://${data['board_phone_1']}'));
                      },
                    ),
                  ),
                  Text(
                    "ติดต่อเรา", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Helpadvice();}
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    "ช่วยแนะนำ", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/noti", arguments: {
                              'total_noti': data['total_noti'],
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: data['total_noti'] == null ? SizedBox(height: 2.0,)
                        :CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            data['total_noti'].toString(),
                            style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  Text(
                    "แจ้งเตือน", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Coin();}
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    "เหรียญ", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
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