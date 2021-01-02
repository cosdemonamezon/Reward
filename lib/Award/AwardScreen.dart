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
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getLinkMember();

  }

  // _getLinkMember() async{
  //   prefs = await SharedPreferences.getInstance();
  //   var tokenString = prefs.getString('token');
  //   var token = convert.jsonDecode(tokenString);

  //   setState(() {
  //     isLoading = true;
  //   });
  //   var url = 'http://103.74.253.96/reward-api/public/api/getLinkMember';
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type':'application/json',
  //       'token': token['token']
  //     },
  //     body: convert.jsonEncode({
  //       'member_id': token['member_id'],
        
  //     })
  //   );
  //   if (response.statusCode == 200){
  //     final Map<String, dynamic> link = convert.jsonDecode(response.body);
  //     if(link['code'] == "200"){
  //       //print(link['massage']);
  //       setState(() {
  //         //data = convert.jsonDecode(profileString);
  //         data = link['data'];
  //         print(data['member_id']);
  //         print(data['member_link_1']);
  //         //print(data['count_turn_over']);
  //         //print(data['member_address']);
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

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
        title: Text("แชร์ลิ้ง"),
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
          Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 280,
                    width: 280,
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/qr.png"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15),
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
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_1']}",
                                      attribute: 'link1',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.favorite),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.copy),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_2']}",
                                      attribute: 'link2',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.favorite),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.copy),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_3']}",
                                      attribute: 'link3',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.favorite),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.copy),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      cursorColor: Theme.of(context).cursorColor,
                                      initialValue: "${data['member_link_4']}",
                                      attribute: 'link4',
                                      decoration: InputDecoration(
                                        enabled: true,
                                        icon: Icon(Icons.favorite),
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.copy),
                                        ),
                                      ),
                                    ),
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
        ]
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