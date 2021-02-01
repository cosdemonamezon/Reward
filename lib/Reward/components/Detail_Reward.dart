import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Reward/constants.dart';

class DetailReward extends StatefulWidget {
  DetailReward({Key key}) : super(key: key);

  @override
  _DetailRewardState createState() => _DetailRewardState();
}

class _DetailRewardState extends State<DetailReward> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String confrim_address_status = 'Yes';
  SharedPreferences prefs;
  bool isLoading = false;
  //List<dynamic> detailreward = [];

  _transferReward(Map<String, dynamic> data)async{
    print(data);
    print(data['member_id']);
    print(data['id']);    
    print(confrim_address_status);
    print(data['member_point']);
    
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/transferReward';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': data['member_id'],
        'reward_id': data['id'],
        'confrim_address_status': confrim_address_status,
        'member_point': data['member_point']
      })
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> detailreward = convert.jsonDecode(response.body);
      print(detailreward);
      if (detailreward['code'] == "200") {
        Alert(
          context: context,
          type: AlertType.success,
          title: detailreward['massage'],
          //desc: detailreward['massage'],
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
      } else if (detailreward['code'] == "400") {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else if (detailreward['code']=="500") {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else if (detailreward['code']=="600") {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "ไปยืนยันที่อยู่",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else if (detailreward['code']=="700") {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else if (detailreward['code']=="800") {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
      else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
      }
    } else {
      final Map<String, dynamic> detailreward = convert.jsonDecode(response.body);
      Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: detailreward['massage'],
          buttons: [
            DialogButton(
              child: Text(
                "กลับหน้าหลัก",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ]
        ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print(data);
    //print(confrim_address_status);
    bool pointStatus = true;

    if (data['transfer_status'] == true &&
        data['group_status'] == true &&
        data['qty_status'] == true) {
      setState(() {
        pointStatus = true;
        //pointStatus = false;
      });
    } else {
      setState(() {
        pointStatus = false;
        // pointStatus = true;
      });
    }
    //print(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Reward"),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "โปรโมชั่นแลกของวันนี้",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${data['title']}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(),
                child: Image.network(
                  data['pic'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${data['description']}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "คะแนน ${data['point']} Point",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: pointStatus == true
                          ? Container(
                              child: FlatButton(
                                onPressed: () {
                                  _transferReward(data);
                                },
                                child: Text(
                                  "แลกรางวัล",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.greenAccent,
                                    Colors.green,
                                    Colors.greenAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            )
                          : Container(
                              child: FlatButton(
                                onPressed: null,
                                child: Text(
                                  "คะแนนไม่พอ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.redAccent,
                                    Colors.red,
                                    Colors.redAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: pointStatus == true
              //   ? SizedBox(height: 5.0,)
              //   : Text(
              //     "แต้มไม่พอ",
              //     style: TextStyle(
              //       color: Colors.red,
              //       fontWeight: FontWeight.bold
              //     ),
              //   ),
              // ),
              GestureDetector(
                  onTap: () {
                    var url = data['url'];
                    launch((url));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("LINK ==> ${data['url']}"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
