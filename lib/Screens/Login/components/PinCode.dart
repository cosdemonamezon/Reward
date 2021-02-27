import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:get_mac/get_mac.dart';
import 'package:flutter/services.dart';
import 'package:device_id/device_id.dart';

class PinCode extends StatefulWidget {
  PinCode({Key key}) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  String _platformVersion = 'Unknown';
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Failed to get Device MAC Address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    String deviceid = await DeviceId.getID;

    setState(() {
      _platformVersion = deviceid;
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

  _createPinMember(String value, Map data) async {
    print(_platformVersion);
    print(data['token']['token']);
    print(data['token']['member_phone']);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + "api/createPinMember";
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'token': data['token']['token'],
        },
        body: convert.jsonEncode({
          'member_pin': value,
          'member_phone': data['token']['member_phone'],
          'member_max_adress': _platformVersion
        }));
    if (response.statusCode == 200) {
      var token = convert.jsonDecode(response.body);
      await prefs.setString('token', response.body);
      //await prefs.setString('token', response.body);
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
        Alert(
            context: context,
            type: AlertType.error,
            title: "${token['massage']}",
            desc: "${token['code']}",
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
      } else if (token['code'] == "500") {
        Alert(
            context: context,
            type: AlertType.error,
            title: "${token['massage']}",
            desc: "${token['code']}",
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
        title: Text("ตั้งค่า PIN"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: 30.0),
              Text(
                "กรุณาตั้งค่า PIN ของคุณ",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(height: 30.0),
              PinCodeTextField(
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
                      _createPinMember(value, data);
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
