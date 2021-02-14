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
  Map<String, dynamic> readnotidata = {};
  
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
          setState(() {
            isLoading = false;
          });
        });
        
        //print(notidata.length);
      } else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            title, picDenied, context,
          ),
        ); 
      }
    }else{
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            title, picDenied, context,
          ),
        ); 
    }
  }

  _readNotiMember(var id)async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(id);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/readNotiMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'noti_log_id': id
      })
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> notiread = convert.jsonDecode(response.body);
      if (notiread['code'] == "200") {
        //print(notiread);
        setState(() {
          //readnotidata = notiread['data'];
          setState(() {
            isLoading = false;
          });
        });
      } else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            title, picDenied, context,
          ),
        ); 
      }
    } else {
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        context: context,
        builder: (context) => dialogDenied(
          title, picDenied, context,
        ),
      ); 
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
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
      body: isLoading == true ? 
      Center(
        child: CircularProgressIndicator(),
      )
      :notidata.length == 0 ?
      Center(
        child: Text(
          "ไม่พบข้อมูล", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      )
      :Container(
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
                  var noti_log_id = notidata[index]['id'];
                  if (notidata[index]['noti_type']=="News") {
                    //launch((url));
                    _readNotiMember(noti_log_id);
                    Navigator.pushNamed(context, "/notidetail", arguments: {
                      'member_point': data['member_point'],
                      'board_phone_1': data['board_phone_1'],
                      'total_noti': data['total_noti'],
                      'title': notidata[index]['title'],
                      'description': notidata[index]['description'],
                      'pic': notidata[index]['pic'],
                      'created_at': notidata[index]['created_at'],
                      'url': notidata[index]['url'],
                    });
                  } else if (notidata[index]['noti_type']=="Point") {
                     _readNotiMember(noti_log_id);
                      Navigator.pushNamed(context, "/point", arguments: {
                      'member_point': data['member_point'],
                      'board_phone_1': data['board_phone_1'],
                      'total_noti': data['total_noti'],
                    });
                  }
                  else if (notidata[index]['noti_type']=="Reward") {
                    Navigator.pushNamed(context, "/reward", arguments: {
                      'member_point': data['member_point'],
                      'board_phone_1': data['board_phone_1'],
                      'total_noti': data['total_noti'],
                    });
                  }
                  else {
                    //print("ไม่มีลิ้ง");
                   
                  }
                  //launch((url));
                },
                child: Card(
                  color: notidata[index]["noti_log_read"] == 0 ? Colors.blue[50]
                  :Colors.white,
                  elevation: 8.0,
                  child: ListTile(
                    leading: notidata[index]["pic"] == null ? Icon(Icons.notifications_active, size: 40,)
                    : Container(
                      width: 70.0,
                      height: 50.0,
                      child: Image.network(notidata[index]['pic'], fit: BoxFit.fill,)
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: notidata[index]['title'].length >= 30 ?
                      Text(
                        "${notidata[index]['title'].substring(0, 30)} ...", style: TextStyle(fontWeight: FontWeight.w400)
                      )
                      :Text(
                        notidata[index]['title'], style: TextStyle(fontWeight: FontWeight.w400)
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: notidata[index]['description'].length >= 50 ?
                      Text(
                        "${notidata[index]['description'].substring(0, 50)} ...", style: TextStyle(fontWeight: FontWeight.w400)
                      )
                      :Text(
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
                    foregroundColor: nbtn1 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
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
                    "ติดต่อเรา", style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
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
                      onTap: (){
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
                        foregroundColor: nbtn3 == true ? Colors.red : Colors.white,
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
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
                        child: data['total_noti'] == null ? SizedBox(height: 2.0,)
                        :data['total_noti'] == 0 ? SizedBox(height: 2.0,)
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
                    foregroundColor: nbtn4 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
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