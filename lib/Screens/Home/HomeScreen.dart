import 'package:Reward/Award/AwardScreen.dart';
import 'package:Reward/Screens/Home/components/Cradit.dart';
import 'package:Reward/Screens/Home/components/DetailCalen.dart';
import 'package:Reward/Screens/Home/components/Profilesettings.dart';
import 'package:Reward/Screens/Home/components/StatusReward.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  //List<dynamic> data = [];

  @override
  void initState() { 
    super.initState();
    _getHomePage();
  }

  _getHomePage() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    // var member_id = tokenpre['member_id'];
    // var token = tokenpre['token'];
    //print(token['token']);
    setState(() {
      isLoading = true;
    });
    var url = 'http://103.74.253.96/reward-api/public/api/getHome_M';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id']
        //'token': token['token']
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> homedata = convert.jsonDecode(response.body);
      //save to prefs
      // await prefs.setString('profile', response.body);
      // var profileString = prefs.getString('profile');
      if(homedata['code'] == "200"){
        print(homedata['massage']);
        setState(() {
          //data = convert.jsonDecode(profileString);
          data = homedata['data'];
          print(data['username']);
        });
        // Flushbar(
        //   title: '${token['massage']}',
        //   message: "${token['code']}",
        //   icon: Icon(
        //     Icons.info_outline,
        //     size: 28.0,
        //     color: Colors.blue[300],
        //   ),
        //   duration: Duration(seconds: 3),
        //   leftBarIndicatorColor: Colors.blue[300],
        // )..show(context);
        // Future.delayed(Duration(seconds: 3), () {
        //   Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        // });
        //Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      }
      else {
        print(homedata['massage']);
        // setState(() {
        //   isLoading = false;
        // });
        // //print(response.body);
        // var feedback = convert.jsonDecode(response.body);
        // Flushbar(
        //   title: '${feedback['message']}',
        //   message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['status_code']}',
        //   backgroundColor: Colors.redAccent,
        //   icon: Icon(
        //     Icons.error,
        //     size: 28.0,
        //     color: Colors.white,
        //     ),
        //   duration: Duration(seconds: 3),
        //   leftBarIndicatorColor: Colors.blue[300],
        // )..show(context);
      }
    }
    else{
      print(response.statusCode);
    }
  }

  _logout() async{
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${data['username']}"),
        //title: Text('55555'),
        leading: IconButton(
          icon: Icon(Icons.settings, size: 35), 
          onPressed: (){
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context){return Profilesettings();}
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.account_circle, size: 35,
              ), 
              onPressed: (){
                _logout();
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
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
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context){return StatusReward();}
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              width: 190,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[200])),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage("assets/images/gold.JPG"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Gold Member", style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
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
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context){return Cradit();}
                                ),
                              );
                            },
                            child: Container(
                              width: 190,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[200])),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage("assets/images/cradit.JPG"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      "Cradit ${data['member_point']}", style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 260,
                    width: 260,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/icons/1.png"),
                      radius: 112,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              // Navigator.push(
                              //   context, MaterialPageRoute(
                              //     builder: (context){return Points();}
                              //   ),
                              // );
                              Navigator.pushNamed(context, '/point', arguments: {
                                'member_sum_point': data['member_sum_point']
                              });
                            },
                            child: Container(
                              height: 166,
                              width: 228,
                              //color: Colors.grey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(pathicon4),
                                          radius: 15,
                                        ),
                                        SizedBox(width: 10.0,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child: Text(
                                            "Point",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Center(
                                      child: Text(
                                        "${data['member_sum_point']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 50, color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),         
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 2.0,),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context){return DetailCalen();}
                                ),
                              );
                            },
                            child: Container(
                              height: 84,
                              width: 220,
                              //color: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      data['count_turn_over'] == null ?
                                      Text(
                                        "เข้าเล่น 0 วัน",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue,
                                        ),
                                      )
                                      : Text(
                                        "เข้าเล่น ${data['count_turn_over']} วัน",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
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
                ],
              ),
              SizedBox(height: 25,),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/1.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                       onTap: (){},
                                    ),
                                  ),
                                ),
                                Text("โอนPoint"),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/2.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: (){},
                                    ),
                                  ),
                                ),
                                Text("เติมเครดิต"),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/3.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: (){},
                                    ),
                                  ),
                                ),
                                Text("ถอนเครดิต"),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/4.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: (){
                                        AppAvailability.launchApp("jp.naver.line.android");
                                        //launch(('https://play.google.com/store/apps/details?id=jp.naver.line.android'));
                                      },
                                    ),
                                  ),
                                ),
                                Text("Line"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/5.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: (){
                                        // Navigator.push(
                                        //   context, MaterialPageRoute(
                                        //     builder: (context){return RewardScreen();}
                                        //   ),
                                        // );
                                        Navigator.pushNamed(context, '/reward', arguments: {
                                          'username': data['username']
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("รีวอร์ด"),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/6.JPG"),
                                  radius: 25,
                                  child: GestureDetector(
                                    onTap: (){
                                      // Navigator.push(
                                      //   context, MaterialPageRoute(
                                      //     builder: (context){return PromotionScreen();}
                                      //   ),
                                      // );
                                      Navigator.pushNamed(context, '/promotion', arguments: {
                                        'username': data['username']
                                      });
                                    },
                                  ),
                                ),
                                Text("โปร/แคมเปญ"),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/7.JPG"),
                                    radius: 25,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                            builder: (context){return AwardScreen();}
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text("รางวัล"),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/8.JPG"),
                                  radius: 25,
                                  child: GestureDetector(
                                    onTap: (){},
                                  ),
                                ),
                                Text("บริการ/เกม"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
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
                        launch(('tel://${data['member_phone']}'));
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
                  CircleAvatar(
                    backgroundImage: AssetImage(pathicon3),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){},
                    ),
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