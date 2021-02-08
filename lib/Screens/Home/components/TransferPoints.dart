import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class TransferPoints extends StatefulWidget {
  TransferPoints({Key key}) : super(key: key);

  @override
  _TransferPointsState createState() => _TransferPointsState();
}

class _TransferPointsState extends State<TransferPoints> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _transferPoint(Map<String, dynamic> values) async{
    print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token['token']);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/transferPoint';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': values['id'],
        'phone_des': values['phone_des'],
        'point': values['point'],
        //'note': values['note'],
          //'token': token['token']
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> point = convert.jsonDecode(response.body);
      if(point['code'] == "200"){
        Alert(
          context: context,
          type: AlertType.info,
          title: "ยืนยันโอน Point",
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
      }
      else{
        print(point['massage']);
        Alert(
          context: context,
          type: AlertType.error,
          title: point['massage'],
          desc: "โปรดตรวจสอบหมายเลขโทรศัพท์อีกครั้ง",
          buttons: [
            DialogButton(
              child: Text(
                "กรอกเบอร์โทรอีกครั้ง",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ]
        ).show();
      }
    }else{
      var comfirm = convert.jsonDecode(response.body);
      print(comfirm['massage']);
      print(response.statusCode);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: comfirm['massage'],
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
    //print(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //toolbarHeight: 150,
        //backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 18,
        //centerTitle: true,
        title: Text("โอน Point"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Text(
                    "จาก : My Account : ${data['username']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color: Colors.blue[100],
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      )],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.account_circle, size: 50,),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data['member_id']} : ${data['member_point']} Point",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                      ),
                                    ],
                                  ), 
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: 20.0,),
            FormBuilder(
              key: _fbKey,
              initialValue: {
                'id': data['id'].toString(),
                'phone_des': '',
                'point': '',
                //'note': '',
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: FormBuilderTextField(
                      attribute: 'point',
                      keyboardType: TextInputType.number,
                      // inputFormatters: [
                      //   ThousandsFormatter()
                      // ],
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        labelText: 'จำนวน',
                        //hintText: 'ใส่ Point ที่ต้องการโอน',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: 'กรุณาระบุแต้มที่จะโอน'),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: FormBuilderTextField(
                      attribute: 'phone_des',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        labelText: 'เบอร์โทร',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: 'กรุณากรอกเบอร์โทรศัพท์'),
                        FormBuilderValidators.maxLength(10, errorText: "กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง")
                      ],
                    ),
                  ),
                  SizedBox(height: 150.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                        },
                        child: Container(
                          height: 50.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff515151),
                                Color(0xffa3a3a3)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Center(
                            child: Text(
                              "ย้อนกลับ", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if (_fbKey.currentState.saveAndValidate()){
                            _transferPoint(_fbKey.currentState.value);
                            setState((){
                              isLoading = true;
                            });
                          }
                        },
                        child: Container(
                          height: 50.0,
                          width: 120.0,
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
                              "โอน Point", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ), 
                    ],
                  ),
                ],
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