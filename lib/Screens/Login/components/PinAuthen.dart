import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';

class PinAuthen extends StatefulWidget {
  PinAuthen({Key key}) : super(key: key);

  @override
  _PinAuthenState createState() => _PinAuthenState();
}

class _PinAuthenState extends State<PinAuthen> {
  final focus = FocusNode();
  String _platformVersion = 'Unknown';
  Future<void> initPlatformState() async {
    String deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _platformVersion = deviceId;
    });
  }

  TextEditingController textEditingController = TextEditingController();
  final String requiredNumber = '12345';
  //final String member_phone = '0922568260';
  //SharedPreferences prefs;
  bool isLoading = false;
  SharedPreferences prefs;
  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
    initPlatformState();
  }

  _authenPinMember(String value, Map data) async {
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + "api/LoginPin";
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(
            {'member_pin': value, 'member_max_adress': _platformVersion}));
    if (response.statusCode == 200) {
      var token = convert.jsonDecode(response.body);
      await prefs.setString('token', response.body);
      if (token['code'] == "200") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        ).show(context);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
        });
      } else if (token['code'] == "400") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        ).show(context);
        focus.requestFocus();
        textEditingController.clear();
      } else if (token['code'] == "500") {
        Flushbar(
          title: '${token['massage']}',
          message: "${token['code']}",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        ).show(context);
        focus.requestFocus();
        textEditingController.clear();
      }
    } else {
      print(response.statusCode);

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
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/loginScreen', (Route<dynamic> route) => false);
              },
            ),
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return Scaffold(
      //backgroundColor: Color(0xFFFFFFFF),
      backgroundColor: Color(0xff050f40),
      appBar: AppBar(
        centerTitle: true,
        title: Text("ยืนยัน PIN"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: 30.0),
              Text(
                "ระบุ PIN เพื่อยืนยันตัวตนเข้าใช้งาน",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(height: 30.0),
              PinCodeTextField(
                  focusNode: focus,
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  appContext: context,
                  length: 5,
                  obscureText: true,
                  obscuringCharacter: '●',
                  onChanged: (value) {
                    print(value);
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    inactiveColor: Colors.red,
                    activeColor: Colors.red,
                    selectedColor: Colors.blue,
                  ),
                  backgroundColor: Color(0xff050f40),
                  enableActiveFill: false,
                  controller: textEditingController,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.white,
                      blurRadius: 1,
                    )
                  ],
                  onCompleted: (value) {
                    if (value.length == 5) {
                      _authenPinMember(value, data);
                      //Navigator.pushNamed(context, "/login");
                    } else {
                      textEditingController.clear();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
