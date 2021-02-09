import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'dart:convert' show utf8, base64;
import 'dart:convert';


class AwardScreen extends StatefulWidget {
  AwardScreen({Key key}) : super(key: key);

  @override
  _AwardScreenState createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> shareLink = {};
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShareLinkReward();
  }
  _getShareLinkReward() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI +'api/getShareLinkReward';
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
      final Map<String, dynamic> shareLinkdata = convert.jsonDecode(response.body);
      if (shareLinkdata['code'] == "200") {
        print(shareLinkdata['massage']);
        setState((){
          shareLink = shareLinkdata['data'];
          //print(shareLink);
          //print(shareLink['pic']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }else{
      print(response.statusCode);
    }
  }

  _shereLinkReward(var shere_reward_id) async{
    
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI +'api/shereLinkReward';
    // print(shere_reward_id);
    // print(token['token']);
    // print(token['member_id']);
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'shere_reward_id': shere_reward_id
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> sharedata = convert.jsonDecode(response.body);
      if (sharedata['code'] == "200") {
        //print(sharedata['massage']);
        Alert(
          context: context,
          type: AlertType.success,
          title: sharedata['massage'],         
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      } 
      else if(sharedata['code'] == "400"){
        //print(sharedata['massage']);
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: sharedata['massage'],
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
      else if(sharedata['code'] == "500"){
        //print(sharedata['massage']);
        Alert(
          context: context,
          type: AlertType.error,
          title: sharedata['massage'],         
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else{
        //print(sharedata['massage']);
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: sharedata['massage'],
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
    }else {
      //print(response.statusCode);
      Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          //desc: sharedata['massage'],
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

  _getlink(int id, int total_noti, String board_phone_1) async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    String encoded = base64Url.encode(utf8.encode( token['member_id'].toString()+"&&"+id.toString()+"&&"+token['token']));
    String url1 = "https://mzreward.com/share_reward/?"+encoded ;

    // Navigator.pushNamed(context, '/webview', arguments: {
    //   'id': data['id'],      
    //   'board_phone_1': board_phone_1,
    //   'total_noti': total_noti,
    //   'url': url1
    // });

    launch(url1);
  }


  
  

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
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
        title: Text("แชร์ลิ้ง"),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.0,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: shareLink['pic'] != null ?
                        Image.network(shareLink['pic'], fit: BoxFit.fill,)
                        :Ink.image(image: NetworkImage('https://picsum.photos/400/200'), fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 10,
                        left: 15,
                        child: Icon(Icons.share, size: 40.0, color: Colors.blue,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        shareLink['title'] == null ? "ไม่มีข้อมูล" :shareLink['title'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        shareLink['description'] == null ? "ไม่มีข้อมูล" :shareLink['description'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              int id = shareLink['id'];
              String board_phone_1 = data['board_phone_1'];
              int total_noti = data['total_noti'];
              _getlink(id, total_noti, board_phone_1);
              // setState(() {
              //   // var id = shareLink['id'];
              //   // _shereLinkReward(id);
              // });            
                 
            },
            child: Container(
              height: 50.0,
              width: 140.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff374ABE),
                    Color(0xff64B6FF)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Center(
                child: Text(
                  "แชร์ลิ้ง", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
                ),
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