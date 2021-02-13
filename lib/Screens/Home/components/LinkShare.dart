import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Reward/constants.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';


class LinkShare extends StatefulWidget {
  LinkShare({Key key}) : super(key: key);

  @override
  _LinkShareState createState() => _LinkShareState();
}

class _LinkShareState extends State<LinkShare> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> shareLink = {};
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController controller = TextEditingController();
  bool i1 = false; bool i2 = false; bool i3 = false; bool i4 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLinkMember();
  }

  _getLinkMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI +'api/getLinkMember';
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> shareLinkdata = convert.jsonDecode(response.body);
      if (shareLinkdata['code'] == "200") {
        //print(shareLinkdata['massage']);
        setState((){
          shareLink = shareLinkdata['data'];
          //print(shareLink);
          //print(shareLink['pic']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            shareLinkdata['massage'], picDenied, context,
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
      // final Map<String, dynamic> homedata = convert.jsonDecode(response.body);
      // Alert(
      //   context: context,
      //   type: AlertType.error,
      //   title: "มีข้อผิดพลาด",
      //   desc: homedata['massage'],
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "ล็อกอินใหม่",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //         onPressed: (){
      //         Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
      //       },
      //     ),
      //   ]
      // ).show();
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
        title: Text("แชร์ลิ้ง"),
      ),
      body: shareLink == null ? 
      Center(
        child: Text(
          "ไม่พบข้อมูล", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      )
      :Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     // image: AssetImage("assets/images/home.jpg", ),
        //     // fit: BoxFit.fill
        //   ),
        // ),
        child: Column(
            children: [
              SizedBox(height: 42.0,),
              Container(
                height: 270,
                width: 270,
                //color: Colors.blue,
                child: shareLink['member_qrcode'] != null ?
                Image.network(shareLink['member_qrcode'], fit: BoxFit.fill,) 
                :
                Image.asset('assets/images/qr.png', fit: BoxFit.fill,),  
              ),
              
              SizedBox(height: 15.0,),

              RaisedButton(
                onPressed: () async{
                  setState(() {
                    i1 = false;
                    i2 = true;
                    i3 = false;
                    i4 = false;                    
                  });
                  launch("https://www.facebook.com/sharer.php?u="+data['member_link_2']);
                  await FlutterClipboard.copy(data['member_link_2']);
                  
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: i1 == true ? LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    :LinearGradient(
                      colors: [Color(0xff616161), Color(0xff757575)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/share2.png"),
                        fit: BoxFit.cover,
                      )
                    ),
                    constraints:
                    BoxConstraints(maxWidth: 340.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [                        
                    //     Text(
                    //       "Share With Local Link",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20.0,
                    //         color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),

              RaisedButton(
                onPressed: () async{
                  setState(() {
                    i1 = false;
                    i2 = false;
                    i3 = false;
                    i4 = true;                    
                  });
                  launch("https://social-plugins.line.me/lineit/share?url="+data['member_link_4']); 
                  await FlutterClipboard.copy(data['member_link_4']);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: i4 == true ? LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    :LinearGradient(
                      colors: [Color(0xff616161), Color(0xff757575)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/share4.png"),
                        fit: BoxFit.cover,
                      )
                    ),
                    constraints:
                    BoxConstraints(maxWidth: 340.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [                        
                    //     Text(
                    //       "Share With Line",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20.0,
                    //         color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),

              SizedBox(height: 15.0,), 
              RaisedButton(
                onPressed: () async{
                  setState(() {
                    i1 = false;
                    i2 = false;
                    i3 = true;
                    i4 = false;                    
                  });
                  launch("https://www.youtube.com/");
                  await FlutterClipboard.copy(data['member_link_3']);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: i3 == true ? LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    :LinearGradient(
                      colors: [Color(0xff616161), Color(0xff757575)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/share3.png"),
                        fit: BoxFit.cover,
                      )
                    ),
                    constraints:
                    BoxConstraints(maxWidth: 340.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [                        
                    //     Text(
                    //       "Share With Youtube",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20.0,
                    //         color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),

              RaisedButton(
                onPressed: () async{
                  setState(() {
                    i1 = true;
                    i2 = false;
                    i3 = false;
                    i4 = false;                    
                  });
                  //launch("https://www.facebook.com/sharer.php?u="+data['member_link_1']);
                  await FlutterClipboard.copy(data['member_link_1']);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: i2 == true ? LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    :LinearGradient(
                      colors: [Color(0xff616161), Color(0xff757575)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/share1.png"),
                        fit: BoxFit.cover,
                      )
                    ),
                    constraints:
                    BoxConstraints(maxWidth: 340.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [                        
                    //     Text(
                    //       "Share With Facebook",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20.0,
                    //         color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),   

              
            ],
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