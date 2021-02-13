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

class _TransferPointsState extends State<TransferPoints> with SingleTickerProviderStateMixin{
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  List<dynamic> logpoint = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TabController tabController;
  bool success = false;

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

  _getlogTransPoint()async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getlogTransPoint';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],        
      })
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> logpointdata = convert.jsonDecode(response.body);
      if (logpointdata['code']=="200") {
        setState(() {
          logpoint = logpointdata['data'];
        });
      } else {
      }
    } else {
    }
  }

  _transferPoint(Map<String, dynamic> values) async{
    //print(values);
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
        'note': values['note'],
          //'token': token['token']
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> point = convert.jsonDecode(response.body);
      if(point['code'] == "200"){
         showDialog(
          context: context,
          builder: (context) => successdialog(
            point['massage'], picSuccess, context,
          ),
         ); 
        // Alert(
        //   context: context,
        //   type: AlertType.info,
        //   title: "ยืนยันโอน Point",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "ยกเลิก",
        //         style: TextStyle(color: Colors.white, fontSize: 18),
        //       ),
        //       onPressed: () => Navigator.pop(context),
        //       color: Color.fromRGBO(0, 179, 134, 1.0),
        //     ),
        //     DialogButton(
        //       child: Text(
        //         "ตกลง",
        //         style: TextStyle(color: Colors.white, fontSize: 18),
        //       ),
        //       onPressed: (){
        //         Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        //       },
        //       gradient: LinearGradient(colors: [
        //         Color.fromRGBO(116, 116, 191, 1.0),
        //         Color.fromRGBO(52, 138, 199, 1.0)
        //       ]),
        //     ),
        //   ],
        // ).show();
      }
      else{
        //print(point['massage']);
        showDialog(
          context: context,
          builder: (context) => errordialog(
            point['massage'], errPhone, picDenied, context,
          ),
        ); 
        // Alert(
        //   context: context,
        //   type: AlertType.error,
        //   title: point['massage'],
        //   desc: "โปรดตรวจสอบหมายเลขโทรศัพท์อีกครั้ง",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "กรอกเบอร์โทรอีกครั้ง",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: (){
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ]
        // ).show();
      }
    }else{
      var comfirm = convert.jsonDecode(response.body);
      print(comfirm['massage']);
      print(response.statusCode);
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        context: context,
        builder: (context) => dialogDenied(
          title, picDenied, context,
         ),
      ); 
      // Alert(
      //   context: context,
      //   type: AlertType.error,
      //   title: "มีข้อผิดพลาด",
      //   desc: comfirm['massage'],
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "ล็อกอินใหม่",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //       onPressed: (){
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
        title: Text("Point"),
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          indicatorWeight: 5.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
          Tab(child: Text("โอน Point"),),
          Tab(child: Text("ประวัติการโอน"),),
        ]),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Text(
                        "จาก : My Account : ${data['username']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
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
                SizedBox(height: 15.0,),
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
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                          validators: [
                            FormBuilderValidators.required(errorText: 'กรุณาระบุแต้มที่จะโอน'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0,),
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
                      SizedBox(height: 15.0,),
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
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                          // validators: [
                          //   FormBuilderValidators.required(errorText: 'กรุณาระบุแต้มที่จะโอน'),
                          // ],
                        ),
                      ),
                      SizedBox(height: 100.0,),
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
                                showDialog(                                
                                context: context,
                                builder: (context) => alertConfrim(
                                  confrimpoint, picWanning, context,
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

          ///Tab 2
          Container(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              itemCount: logpoint.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 8.0,
                    child: ListTile(
                      title: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("โอน Point", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  logpoint[index]['amount'].toString()+" Point", 
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(logpoint[index]['createdTime'],style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          Divider(height: 2, thickness: 3,),
                          SizedBox(height: 5,),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ชื่อบัญชี :", ),
                                Text(logpoint[index]['username_des'], style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("เบอร์โทร :"),
                                Text(logpoint[index]['phone_des'], style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
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

  alertConfrim (String title, String img, context,){
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
              left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
            ),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                blurRadius: 10
              ),]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),              
                SizedBox(height: 22,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFFD50000),
                        child: Text('ยกเลิก', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: (){
                          setState(() {
                            success = true;
                          });
                          if (success == true) {
                            _transferPoint(_fbKey.currentState.value);
                            setState((){
                              isLoading = true;
                            });
                          } else {
                          }
                          //Navigator.pushNamed(context, '/transfer', (Route<dynamic> route) => false);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFF01579B),
                        child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(img)
              ),
            ),
          ),
        ],
      ),
    );
  }
}