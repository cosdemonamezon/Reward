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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home.jpg", ),
            fit: BoxFit.fill
          ),
        ),
        child: SingleChildScrollView(
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
                Image.asset('assets/images/nopic.png', fit: BoxFit.fill,),  
              ),
              
              SizedBox(height: 15.0,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
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
                        child: FormBuilder(
                          key: _fbKey,
                          initialValue: {
                            'link1': data['member_link_1'],
                            'link2': data['member_link_2'],
                            'link3': data['member_link_3'],
                            'link4': data['member_link_4']
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 320,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      enabled: false,
                                      readOnly: true,
                                      enableInteractiveSelection: false,
                                      //controller: controller,
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_1']}",
                                      attribute: 'link1',
                                      decoration: InputDecoration(
                                        //hintText: "${data['member_link_1']}",
                                        enabled: true,
                                        icon: Icon(Icons.share_sharp),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        // suffixIcon: IconButton(
                                        //   onPressed: () async {
                                        //     // setState(() {
                                        //     //   controller = data['member_link_1'];
                                        //     // });
                                        //     await FlutterClipboard.copy(data['member_link_1']);
                                        //   },
                                        //   icon: Icon(Icons.copy),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: ()async{
                                      setState(() {
                                        i1 = true;
                                        i2 = false;
                                        i3 = false;
                                        i4 = false;
                                      });
                                      await FlutterClipboard.copy(data['member_link_1']);
                                    },
                                    icon: i1 == true ? Icon(Icons.copy, color: Colors.blue,)
                                    :Icon(Icons.copy),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 320,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      enabled: false,
                                      readOnly: true,
                                      enableInteractiveSelection: false,
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_2']}",
                                      attribute: 'link2',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.share_sharp),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: ()async{
                                      setState(() {
                                        i1 = false;
                                        i2 = true;
                                        i3 = false;
                                        i4 = false;
                                      });
                                      await FlutterClipboard.copy(data['member_link_2']);
                                    },
                                    icon: i2 == true ? Icon(Icons.copy, color: Colors.blue,)
                                    :Icon(Icons.copy),
                                  ),
                                ],
                              ),
                                      
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 320,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      enabled: false,
                                      readOnly: true,
                                      enableInteractiveSelection: false,
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_3']}",
                                      attribute: 'link3',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.share_sharp),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        // suffixIcon: IconButton(
                                        //   onPressed: ()async{
                                        //     await FlutterClipboard.copy(data['member_link_3']);
                                        //   },
                                        //   icon: Icon(Icons.copy),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: ()async{
                                      setState(() {
                                        i1 = false;
                                        i2 = false;
                                        i3 = true;
                                        i4 = false;
                                      });
                                      await FlutterClipboard.copy(data['member_link_3']);
                                    },
                                    icon: i3 == true ? Icon(Icons.copy, color: Colors.blue,)
                                    :Icon(Icons.copy),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 320,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      enabled: false,
                                      readOnly: true,
                                      enableInteractiveSelection: false,
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_4']}",
                                      attribute: 'link4',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.share_sharp),
                                        labelStyle: TextStyle(
                                            color: Color(0xFF6200EE),
                                        ),
                                        
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: ()async{
                                      setState(() {
                                        i1 = false;
                                        i2 = false;
                                        i3 = false;
                                        i4 = true;
                                      });
                                      await FlutterClipboard.copy(data['member_link_4']);
                                    },
                                    icon: i4 == true ? Icon(Icons.copy, color: Colors.blue,)
                                    :Icon(Icons.copy),
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
              SizedBox(height: 80.0,),
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
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
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
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
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