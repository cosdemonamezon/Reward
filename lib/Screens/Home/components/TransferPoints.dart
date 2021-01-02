import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';

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
    var url = 'http://103.74.253.96/reward-api/public/api/transferPoint';
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
        //print(point['massage']);
        // SweetAlert.show(context,
        //   title: "${point['massage']}",
        //   subtitle: "",
        //   style: SweetAlertStyle.confirm,
        //   showCancelButton: true, onPress: (bool isConfirm) {
        //     if (isConfirm) {
        //       SweetAlert.show(context,
        //         style: SweetAlertStyle.success, title: "ยืนยัน");
        //         Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        //       return false;
        //     }
        //   });


        Flushbar(
          title: '${point['massage']}',
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
      }
      else{
        print(point['massage']);
      }
    }else{
      var comfirm = convert.jsonDecode(response.body);
      print(comfirm['massage']);
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
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
        title: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("โอน Point"),
              ],
            ),
            Row(
              children: [
                Text("จาก :"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 50,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("My Account : ${data['username']}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${data['member_id']}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${data['member_point']} Point",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ข้อมูล ณ เวลา 14.00 น.",
                  style: TextStyle(fontSize: 14.0, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Text(
                    "ไปยัง: บัญชีสมาชิก", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                        color: Color.fromRGBO(255, 95, 27, .3),
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
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: AssetImage("assets/images/gold.JPG"),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  //"User Member : ${data['username']}",
                                  "${data['group_member_name']}  :  ${data['username']}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
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
                      inputFormatters: [
                        ThousandsFormatter()
                      ],
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
                  SizedBox(height: 50.0,),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   child: FormBuilderTextField(
                  //     attribute: 'note',
                  //     keyboardType: TextInputType.multiline,
                  //     textAlign: TextAlign.start,
                  //     maxLines: 5,
                  //     decoration: InputDecoration(
                  //       labelText: 'บันทึกช่วยจำ',
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Color(0xFF6200EE)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                  SizedBox(height: 80.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        label: Text(
                          "ยกเลิก", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.redAccent),
                        ),
                        icon: Icon(Icons.cancel_outlined, size: 50, color: Colors.redAccent,),
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                        },
                      ),
                      TextButton.icon(
                        label: Text(
                          "โอน Point", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.green),
                        ),
                        icon: Icon(Icons.check_circle_outline, size: 50, color: Colors.green,),
                        onPressed: (){
                          if (_fbKey.currentState.saveAndValidate()){
                            _transferPoint(_fbKey.currentState.value);
                            setState((){
                              isLoading = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  // Container(
                  //   child: FlatButton(
                  //     onPressed: () {
                  //       if (_fbKey.currentState.saveAndValidate()){
                  //         _transferPoint(_fbKey.currentState.value);
                  //         setState((){
                  //           isLoading = true;
                  //         });
                  //       }
                  //     },
                  //     child: Text(
                  //       "โอน Point", 
                  //       style: TextStyle(color: Colors.white, fontSize: 20),
                  //     ),
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     gradient: LinearGradient(
                  //       colors: [                            
                  //         Colors.grey[50],
                  //         Colors.greenAccent,
                  //         Colors.greenAccent, 
                  //         Colors.greenAccent,
                  //         Colors.grey[50],
                  //       ],
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //     ),
                  //   ),
                  // )
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