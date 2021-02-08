import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:Reward/constants.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:url_launcher/url_launcher.dart';

class NotiScreen extends StatefulWidget {
  NotiScreen({Key key}) : super(key: key);

  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotiMember();
  }
  

  _getNotiMember()async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token['token']);
    //print(token['member_id']);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getNotiMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id']
      })
    );
    if (response.statusCode == 200){
      //print(response.statusCode);
      final Map<String, dynamic> notinumber = convert.jsonDecode(response.body);
      //print(notinumber);
      if (notinumber['code'] == "200") {
        setState(() {
          notidata = notinumber['data'];
        });
        
        print(notidata.length);
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "ข้อผิดพลาดภายในเซิร์ฟเวอร์",
          desc: response.statusCode.toString(),
          buttons: [
            DialogButton(
              child: Text(
                "ล็อกอินใหม่",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Notification Log"),
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notidata.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: (){
                  var url = notidata[index]['url'];
                  if (url != null) {
                    launch((url));
                  } else {
                    print("ไม่มีลิ้ง");
                  }
                  //launch((url));
                },
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: Icon(Icons.notifications_active),
                    title: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        notidata[index]['title'], style: TextStyle(fontWeight: FontWeight.w400)
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        notidata[index]['description'], style: TextStyle(fontWeight: FontWeight.w400)
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            );
          }
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
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context){return NotiScreen();}
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: notidata.length == 0 ? SizedBox(height: 2.0,)
                        :CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            notidata.length.toString(),
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