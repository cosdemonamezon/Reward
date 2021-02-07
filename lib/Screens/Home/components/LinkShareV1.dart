import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Reward/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


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
    } else {
      final Map<String, dynamic> homedata = convert.jsonDecode(response.body);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: homedata['massage'],
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          //SingleChildScrollView(child: Image.asset("assets/images/home.jpg", fit: BoxFit.cover,)),
          Image.asset("assets/images/home.jpg", fit: BoxFit.cover,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.7),
          ),
          
          Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    //color: Colors.blue,
                    child: shareLink['member_qrcode'] != null ?
                    Image.network(shareLink['member_qrcode'], fit: BoxFit.fill,) :
                    Image.network('https://picsum.photos/400/200', fit: BoxFit.fill,),
                    
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
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
    );
  }
}