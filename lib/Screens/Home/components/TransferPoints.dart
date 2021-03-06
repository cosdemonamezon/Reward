import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TransferPoints extends StatefulWidget {
  TransferPoints({Key key}) : super(key: key);

  @override
  _TransferPointsState createState() => _TransferPointsState();
}

class _TransferPointsState extends State<TransferPoints>
    with SingleTickerProviderStateMixin {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> logpoint = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TabController tabController;
  bool success = false;
  SharedPreferences prefsNoti;
  Map<String, dynamic> numberNoti = {};
  bool _isButtonDisabled = false;
  String limitPoint = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _getlogTransPoint();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  _getlogTransPoint() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var profile = prefs.getString('profile');
    var tokenprofile = convert.jsonDecode(profile);

    setState(() {
      limitPoint = tokenprofile['data']['tranfer_point_limit'].toString();
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    prefsNoti = await SharedPreferences.getInstance();
    var notiString = prefsNoti.getString('notification');
    var noti = convert.jsonDecode(notiString);
    setState(() {
      isLoading = true;
      numberNoti = noti['data'];
    });
    if (numberNoti['member_activate'] == "No") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alertConfirmUsername(
          settitle,
          comfirmUse,
          picWanning,
          context,
        ),
      );
    }
    var url = pathAPI + 'api/getlogTransPoint';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({ }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> logpointdata =
          convert.jsonDecode(response.body);
      if (logpointdata['code'] == "200") {
        setState(() {
          logpoint = logpointdata['data'];
        });
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            logpointdata['massage'],
            picDenied,
            context,
          ),
        );
      }
    } else {
      if (response.statusCode == 400) {
        final Map<String, dynamic> logpointdata =
            convert.jsonDecode(response.body);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            logpointdata['massage'],
            picDenied,
            context,
          ),
        );
      }
    }
  }

  _transferPoint(Map<String, dynamic> values) async {
    //print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token['token']);

    setState(() {
      isLoading = true;
      _isButtonDisabled = true;
    });
    var url = pathAPI + 'api/transferPoint';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({
          'member_id': values['id'],
          'phone_des': values['phone_des'],
          'point': values['point'],
          'note': values['note'],
          //'token': token['token']
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> point = convert.jsonDecode(response.body);
      if (point['code'] == "200") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => successdialog(
            point['massage'],
            picSuccess,
            context,
          ),
        );
      } else if (point['code'] == "400") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            point['massage'],
            picWanning,
            context,
          ),
        );
      } else if (point['code'] == "500") {
        setState(() {          
          _isButtonDisabled = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            point['massage'],
            picWanning,
            context,
          ),
        );
      } else if (point['code'] == "600") {
        setState(() {          
          _isButtonDisabled = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            point['massage'],
            picWanning,
            context,
          ),
        );
      } else {
        //print(point['massage']);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            point['massage'],
            errPhone,
            picDenied,
            context,
          ),
        );
        
      }
    } else {
      var comfirm = convert.jsonDecode(response.body);
      print(comfirm['massage']);
      print(response.statusCode);
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          title,
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    if (data['member_activate'] == "No") {}
    //print(data);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: hexToColor("#" + template_kNavigationBarColor),
          centerTitle: true,
          //toolbarHeight: 150,
          //backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
          elevation: 18,
          //centerTitle: true,
          title: Text("โอน Point"),
          bottom: TabBar(
            labelColor: hexToColor("#" +template_kNavigationFooterBarColor),
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("โอน Point", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ประวัติการโอน", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          //controller: tabController,
          children: [
            logpoint == null
                ? Center(
                    child: Text(
                      "ไม่พบข้อมูล",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: hexToColor(
                              "#" + template_kNavigationFooterBarColor)),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: Text(
                                "จาก : My Account : ${data['username']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 5.0),
                          child: Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue[100],
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200])),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 50,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Point : ${data['member_point']}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0),
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
                          ]),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FormBuilder(
                          key: _fbKey,
                          initialValue: {
                            'id': data['id'].toString(),
                            'phone_des': '',
                            'point': '',
                            'note': '',
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
                                      borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'กรุณาระบุแต้มที่จะโอน'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: FormBuilderTextField(
                                  attribute: 'phone_des',
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    labelText: 'เบอร์โทร',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'กรุณากรอกเบอร์โทรศัพท์'),
                                    FormBuilderValidators.maxLength(10,
                                        errorText:
                                            "กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: FormBuilderTextField(
                                  maxLines: 3,
                                  attribute: 'note',
                                  keyboardType: TextInputType.name,
                                  // inputFormatters: [
                                  //   ThousandsFormatter()
                                  // ],
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    labelText: 'โน๊ต',
                                    //hintText: 'ใส่ Point ที่ต้องการโอน',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF6200EE)),
                                    ),
                                  ),
                                  // validators: [
                                  //   FormBuilderValidators.required(errorText: 'กรุณาระบุแต้มที่จะโอน'),
                                  // ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: Text(
                                  "**จำนวนขั้นต่ำที่โอนได้คือ  "+limitPoint+"  Point**",
                                  style: TextStyle(
                                    fontSize: 12.0, fontWeight: FontWeight.bold,
                                    color: Colors.red
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, "/home", (route) => false);
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
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Text(
                                          "ย้อนกลับ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_fbKey.currentState.saveAndValidate()) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => alertConfrim(
                                            confrimpoint,
                                            picWanning,
                                            context,
                                          ),
                                        );
                                        // if (success == true) {
                                        //   _transferPoint(_fbKey.currentState.value);
                                        //   setState((){
                                        //     isLoading = true;
                                        //   });
                                        // } else {
                                        // }
                                        // _transferPoint(_fbKey.currentState.value);
                                        // setState((){
                                        //   isLoading = true;
                                        // });
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
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Text(
                                          "โอน Point",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.white),
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

            ///Tab 2
            logpoint.length == 0
                ? Center(
                    child: Text(
                      "ไม่พบข้อมูล",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: hexToColor(
                              "#" + template_kNavigationFooterBarColor)),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      itemCount: logpoint.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 8.0,
                            child: ListTile(
                              title: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("โอน Point",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            logpoint[index]['amount'].toString() +
                                                " Point",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(logpoint[index]['createdTime'],
                                            style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    height: 2,
                                    thickness: 3,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ชื่อบัญชี :",
                                        ),
                                        Text(logpoint[index]['username_des'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("เบอร์โทร :"),
                                        Text(logpoint[index]['phone_des'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("โน๊ต : " + logpoint[index]['note']),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(logpoint[index]['createdDate']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
            color: hexToColor("#" + template_kNavigationBarColor),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 15.0, bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor:nbtn1 == true ?
                         Colors.white54  : hexToColor("#" + template_kNavigationFooterBarColor),
                      foregroundColor: nbtn1 == true ? Colors.red : Colors.white,
                      backgroundImage: AssetImage(pathicon1),
                      radius: 24,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            nbtn1 = true;
                            nbtn2 = false;
                            nbtn3 = false;
                            nbtn4 = false;
                          });
                          //launch(('tel://${item.mobile_no}'));
                          //launch(('tel://0922568260'));
                          launch(('tel://${numberNoti['board_phone_1']}'));
                        },
                      ),
                    ),
                    Text(
                      "ติดต่อเรา",
                      style: TextStyle(
                          color: kTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          hexToColor("#" + template_kNavigationFooterBarColor),
                      foregroundColor: nbtn2 == true ? Colors.red : Colors.white,
                      backgroundImage: AssetImage(pathicon2),
                      radius: 24,
                      child: GestureDetector(
                        onTap: () {
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
                      "ช่วยแนะนำ",
                      style: TextStyle(
                          color: kTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: hexToColor(
                              "#" + template_kNavigationFooterBarColor),
                          foregroundColor:
                              nbtn3 == true ? Colors.red : Colors.white,
                          backgroundImage: AssetImage(pathicon3),
                          radius: 24,
                          child: GestureDetector(
                            onTap: () {
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
                          child: numberNoti['total_noti'] == null
                              ? SizedBox(
                                  height: 2.0,
                                )
                              : numberNoti['total_noti'] == 0
                                  ? SizedBox(
                                      height: 2.0,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 10,
                                      child: Text(
                                        numberNoti['total_noti'].toString(),
                                        style: TextStyle(
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                    Text(
                      "แจ้งเตือน",
                      style: TextStyle(
                          color: kTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          hexToColor("#" + template_kNavigationFooterBarColor),
                      foregroundColor: nbtn4 == true ? Colors.red : Colors.white,
                      backgroundImage: AssetImage(pathicon4),
                      radius: 24,
                      child: GestureDetector(
                        onTap: () {
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
                      "เหรียญ",
                      style: TextStyle(
                          color: kTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  alertConfrim(
    String title,
    String img,
    context,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFFD50000),
                        child: Text('ยกเลิก',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          setState(() {
                            success = true;
                          });
                          if (success == true) {
                            if (_isButtonDisabled == false) {
                              _transferPoint(_fbKey.currentState.value);
                              setState(() {
                                isLoading = true;
                              });
                            } else {
                            }
                            
                          } else {}
                          //Navigator.pushNamed(context, '/transfer', (Route<dynamic> route) => false);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFF01579B),
                        child: Text('ตกลง',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset(img)),
            ),
          ),
        ],
      ),
    );
  }

  alertConfirmUsername(
    String title,
    String subtitle,
    String img,
    context,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  comfirmUse,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profilesetting',
                              arguments: {
                                'id': data['id'],
                                'username': data['username'],
                                'member_name_th': data['member_name_th'],
                                'member_name_en': data['member_name_en'],
                                'member_email': data['member_email'],
                                'member_address': data['member_address'],
                                'member_activate': data['member_activate'],
                                'board_phone_1': data['board_phone_1'],
                                'total_noti': data['total_noti'],
                              });
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFFD50000),
                        child: Text('ยืนยันสมาชิก',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/home',
                              (Route<dynamic> route) => false);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFF01579B),
                        child: Text('ไปหน้าหลัก',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset(img)),
            ),
          ),
        ],
      ),
    );
  }
}
