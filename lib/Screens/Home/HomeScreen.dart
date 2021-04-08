import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  SharedPreferences prefsNoti;
  bool isLoading = false;
  bool loadSuccess = false;
  Map<String, dynamic> data = {};
  List<dynamic> notidata = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;
  //List<dynamic> data = [];
  var token_home;

  _initPrefs() async {
    prefsNoti = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    //_checkLogin();
    //_checkTokenExp();
    _getHomePage();
    _initPrefs();
  }

  _checkTokenExp() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token['token']);
    // bool isTokenExpired = JwtDecoder.isExpired(token['token']);

    // if (!isTokenExpired) {
    //   Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
    // } else {
    // }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    //_checkTokenExp();
    _getHomePage(); //ทุกครั้งที่ทำการรีเฟรช จะดึงข้อมูลใหม่

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    //_checkTokenExp();
    _getHomePage();

    //_refreshController.loadComplete();
    _refreshController.loadNoData();
    _refreshController.resetNoData();
  }

  _getHomePage() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });
    // var member_id = tokenpre['member_id'];
    // var token = tokenpre['token'];
    //print(token['token']);
    bool isTokenExpired = JwtDecoder.isExpired(token['token']);

    try {
      if (!isTokenExpired) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginScreen', (Route<dynamic> route) => false);
      } else {
        setState(() {
          isLoading = true;
        });
        var url = pathAPI + 'api/getHome_M';
        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'token': token['token']
            },
            body: convert.jsonEncode({
              'member_id': token['member_id']
              //'token': token['token']
            }));
        if (response.statusCode == 200) {
          var notification = convert.jsonDecode(response.body);
          await prefsNoti.setString('notification', response.body);
          //print(notification);
          final Map<String, dynamic> homedata =
              convert.jsonDecode(response.body);
          //var notification = convert.jsonDecode(response.body);
          //await prefsNoti.setString('notification', response.body);
          //save to prefs
          await prefs.setString('profile', response.body);
          //var profileString = prefs.getString('profile');
          if (homedata['code'] == "200") {
            //print(homedata);
            //await prefsNoti.setString('notification', response.body);
            setState(() {
              //data = convert.jsonDecode(profileString);
              data = homedata['data'];

              nbtn1 = false;
              nbtn2 = false;
              nbtn3 = false;
              nbtn4 = false;
              loadSuccess = true;
              isLoading = false;
            });
          } else {
            //print(homedata['massage']);
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => dialogDenied(
                homedata['massage'],
                picDenied,
                context,
              ),
            );
          }
        } else {
          print(response.statusCode);

          Navigator.pushNamedAndRemoveUntil(
              context, '/loginScreen', (Route<dynamic> route) => false);
          return false;
        }
      }
    } catch (e) {}
  }

  _receivePointTurnOver() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI + 'api/receivePointTurnOver';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> receivePoint =
          convert.jsonDecode(response.body);
      if (receivePoint['code'] == "200") {
        //print(receivePoint['massage']);
        //initState();
        //_getHomePage();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            receivePoint['massage'],
            picSuccess,
            context,
          ),
        );
        // Navigator.pushNamedAndRemoveUntil(
        //     context, '/home', (Route<dynamic> route) => false);
      } else {
        //String title = "ไม่พบข้อมูล";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            receivePoint['massage'],
            picDenied,
            context,
          ),
        );
      }
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> receivePoint =
          convert.jsonDecode(response.body);
      // String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          receivePoint['massage'],
          picDenied,
          context,
        ),
      );
    } else {
      final Map<String, dynamic> receivePoint =
          convert.jsonDecode(response.body);
      // String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          receivePoint['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  // _logout() async{
  //   prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('token');
  //   Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#" + template_kNavigationBarColor),
        centerTitle: true,
        title: data['username'] == null
            ? Text("กำลังโหลด..")
            : Text("${data['username']}"),
        //title: Text('55555'),
        leading: IconButton(
          icon: Icon(Icons.settings, size: 35),
          onPressed: () {
            if (loadSuccess == true) {
              Navigator.pushNamed(context, '/profilesetting', arguments: {
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
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 35,
              ),
              onPressed: () {
                //_logout();
                if (loadSuccess == true) {
                  Navigator.pushNamed(context, '/share', arguments: {
                    'id': data['id'],
                    'username': data['username'],
                    'member_name_th': data['member_name_th'],
                    'member_name_en': data['member_name_en'],
                    'member_email': data['member_email'],
                    'member_address': data['member_address'],
                    'member_activate': data['member_activate'],
                    'member_link_1': data['member_link_1'],
                    'member_link_2': data['member_link_2'],
                    'member_link_3': data['member_link_3'],
                    'member_link_4': data['member_link_4'],
                    'board_phone_1': data['board_phone_1'],
                    'total_noti': data['total_noti'],
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data == null
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
              : SmartRefresher(
                  // enablePullDown: false,
                  // enablePullUp: true,
                  header: WaterDropMaterialHeader(
                    color: Colors.white,
                    backgroundColor:
                        hexToColor("#" + template_kNavigationFooterBarColor),
                    // refreshStyle: RefreshStyle.Follow,
                    // refreshingText: 'กำลังโหลด.....',
                    // completeText: 'โหลดข้อมูลสำเร็จ',
                  ),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("");
                      } else if (mode == LoadStatus.loading) {
                        body = CircularProgressIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else if (mode == LoadStatus.noMore) {
                        //body = Text("No more Data");
                        body = Text("");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(255, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(1, 1),
                                          )
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/status',
                                              arguments: {
                                                'board_phone_1':
                                                    data['board_phone_1'],
                                                'total_noti':
                                                    data['total_noti'],
                                              });
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(4.4),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[200])),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/gold.JPG"),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    "${data['group_member_name']}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.6),
                                                  ),
                                                ),
                                                Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(255, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 8),
                                          )
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/cradit',
                                              arguments: {
                                                'credit': data['credit'],
                                                'board_phone_1':
                                                    data['board_phone_1'],
                                                'total_noti':
                                                    data['total_noti'],
                                              });
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            padding: EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey[200])),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/cradit.JPG"),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    "Credit ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.6),
                                                  ),
                                                ),
                                                Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 260,
                                width: 260,
                                color: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 120,
                                  child: Stack(
                                    children: [
                                      data['count_turn_over_circle'] == null
                                          ? Image.network(
                                              pathAPI +
                                                  "images/color/28/blue/0.png",
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              data['count_turn_over_circle'],
                                              fit: BoxFit.cover,
                                            ),
                                      Positioned(
                                        top: 0.5,
                                        left: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/point',
                                                arguments: {
                                                  'member_point':
                                                      data['member_point'],
                                                  'board_phone_1':
                                                      data['board_phone_1'],
                                                  'total_noti':
                                                      data['total_noti'],
                                                });
                                          },
                                          child: Container(
                                            height: 166,
                                            width: 228,
                                            //color: Colors.grey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            hexToColor("#" +
                                                                template_kNavigationFooterBarColor),
                                                        backgroundImage:
                                                            AssetImage(
                                                                pathicon4),
                                                        radius: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0),
                                                        child: Text(
                                                          "Point",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                            color: hexToColor("#" +
                                                                template_kNavigationFooterBarColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  child: Center(
                                                    child: data['member_point']
                                                                .toString()
                                                                .length ==
                                                            6
                                                        ? Text(
                                                            NumberFormat("#,###")
                                                                .format(data[
                                                                    'member_point']),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 46,
                                                              color:
                                                                  Colors.black,
                                                            ))
                                                        : data['member_point']
                                                                    .toString()
                                                                    .length ==
                                                                7
                                                            ? Text(
                                                                NumberFormat("#,###")
                                                                    .format(data[
                                                                        'member_point']),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 44,
                                                                  color: Colors
                                                                      .black,
                                                                ))
                                                            : data['member_point']
                                                                        .toString()
                                                                        .length ==
                                                                    8
                                                                ? Text(
                                                                    NumberFormat("#,###")
                                                                        .format(data['member_point']),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          42,
                                                                      color: Colors
                                                                          .black,
                                                                    ))
                                                                : data['member_point'].toString().length == 9
                                                                    ? Text(NumberFormat("#,###").format(data['member_point']),
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              40,
                                                                          color:
                                                                              Colors.black,
                                                                        ))
                                                                    : Text("${data['member_point']}",
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              50,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Positioned(
                                        bottom: 7,
                                        right: 3,
                                        left: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context, MaterialPageRoute(
                                            //     builder: (context){return DetailCalen();}
                                            //   ),
                                            // );
                                          },
                                          child: Container(
                                            height: 84,
                                            width: 220,
                                            //color: Colors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //SizedBox(height: 10.0,),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    data['btn_receive_reward7day'] ==
                                                            true
                                                        ? TextButton(
                                                            child: Text(
                                                              "กดรับรางวัล",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25,
                                                                color: hexToColor(
                                                                    "#" +
                                                                        template_kNavigationFooterBarColor),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        confrim(
                                                                  rewardConfirm,
                                                                  picWanning,
                                                                  context,
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        // RaisedButton(
                                                        //   onPressed: (){

                                                        //     SweetAlert.show(context,
                                                        //         title: "Just show a message",
                                                        //         subtitle: "Sweet alert is pretty",
                                                        //         style: SweetAlertStyle.confirm,
                                                        //         showCancelButton: true, onPress: (bool isConfirm) {
                                                        //       if (isConfirm) {
                                                        //         SweetAlert.show(context,
                                                        //             style: SweetAlertStyle.success, title: "Success");
                                                        //             _receivePointTurnOver();
                                                        //         // return false to keep dialog
                                                        //         return false;
                                                        //       }
                                                        //     });
                                                        //     //_receivePointTurnOver();
                                                        //   },
                                                        //   shape: RoundedRectangleBorder(
                                                        //     borderRadius: new BorderRadius.circular(20.0),
                                                        //     side: BorderSide(color: Colors.blueAccent),
                                                        //   ),
                                                        //   elevation: 10.0,
                                                        //   colorBrightness: Brightness.light,
                                                        //   color: Colors.greenAccent,
                                                        //   textColor: Colors.black,
                                                        //   splashColor: Colors.yellowAccent,
                                                        //   animationDuration: Duration(seconds: 2),
                                                        //   child: Text(
                                                        //     "กดรับรางวัล",
                                                        //     style: TextStyle(
                                                        //       fontWeight: FontWeight.bold, fontSize: 20,
                                                        //     ),
                                                        //   ),
                                                        // )
                                                        : data['count_turn_over'] ==
                                                                null
                                                            ? Text(
                                                                "เข้าเล่น 0 วัน",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: hexToColor(
                                                                      "#" +
                                                                          template_kNavigationFooterBarColor),
                                                                ),
                                                              )
                                                            : Text(
                                                                "เข้าเล่น ${data['count_turn_over']} วัน",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: hexToColor(
                                                                      "#" +
                                                                          template_kNavigationFooterBarColor),
                                                                ),
                                                              ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                          SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/1.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, "/transfer",
                                                        arguments: {
                                                          'id': data['id'],
                                                          'member_id':
                                                              data['member_id'],
                                                          'username':
                                                              data['username'],
                                                          'member_name_th': data[
                                                              'member_name_th'],
                                                          'member_point': data[
                                                              'member_point'],
                                                          'group_member_name': data[
                                                              'group_member_name'],
                                                          'board_phone_1': data[
                                                              'board_phone_1'],
                                                          'total_noti': data[
                                                              'total_noti'],
                                                          'member_name_en': data[
                                                              'member_name_en'],
                                                          'member_email': data[
                                                              'member_email'],
                                                          'member_address': data[
                                                              'member_address'],
                                                          'member_activate': data[
                                                              'member_activate'],
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("โอนPoint"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/2.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    launch(data[
                                                        'board_url_deposit']);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("เติมเครดิต"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/3.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    launch(data[
                                                        'board_url_withdraw']);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("ถอนเครดิต"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/4.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    AppAvailability.launchApp(
                                                        "jp.naver.line.android");
                                                    //launch(('https://play.google.com/store/apps/details?id=jp.naver.line.android'));
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("Line"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/5.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/reward',
                                                        arguments: {
                                                          'member_id':
                                                              data['member_id'],
                                                          'username':
                                                              data['username'],
                                                          'member_name_en': data[
                                                              'member_name_en'],
                                                          'member_name_th': data[
                                                              'member_name_th'],
                                                          'member_email': data[
                                                              'member_email'],
                                                          'member_phone': data[
                                                              'member_phone'],
                                                          'member_point': data[
                                                              'member_point'],
                                                          'board_phone_1': data[
                                                              'board_phone_1'],
                                                          'total_noti': data[
                                                              'total_noti'],
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("รีวอร์ด"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/6.JPG"),
                                              radius: 25,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/promotion',
                                                      arguments: {
                                                        'username':
                                                            data['username'],
                                                        'board_phone_1': data[
                                                            'board_phone_1'],
                                                        'total_noti':
                                                            data['total_noti'],
                                                      });
                                                },
                                              ),
                                            ),
                                            Text("โปร/แคมเปญ"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/7.JPG"),
                                                radius: 25,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/award',
                                                        arguments: {
                                                          'id': data['id'],
                                                          'member_link_1': data[
                                                              'member_link_1'],
                                                          'member_link_2': data[
                                                              'member_link_2'],
                                                          'member_link_3': data[
                                                              'member_link_3'],
                                                          'member_link_4': data[
                                                              'member_link_4'],
                                                          'board_phone_1': data[
                                                              'board_phone_1'],
                                                          'total_noti':
                                                              data['total_noti']
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Text("รางวัล"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/8.JPG"),
                                              radius: 25,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) =>
                                                        dialogAlert(
                                                      noService,
                                                      picWanning,
                                                      context,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Text("บริการ/เกม"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    backgroundColor: nbtn1 == true
                        ? Colors.white54
                        : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        if (loadSuccess == true) {
                          launch(('tel://${data['board_phone_1']}'));
                        }
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
                    backgroundColor: nbtn2 == true
                        ? Colors.white54
                        : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        if (loadSuccess == true) {
                          Navigator.pushNamed(context, "/help", arguments: {
                            'member_point': data['member_point'],
                            'board_phone_1': data['board_phone_1'],
                            'total_noti': data['total_noti'],
                          });
                        }
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
                        backgroundColor: nbtn3 == true
                            ? Colors.white54
                            : hexToColor(
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
                            if (loadSuccess == true) {
                              Navigator.pushNamed(context, "/noti", arguments: {
                                'member_id': data['member_id'],
                                'member_name_en': data['member_name_en'],
                                'member_name_th': data['member_name_th'],
                                'member_email': data['member_email'],
                                'member_phone': data['member_phone'],
                                'member_point': data['member_point'],
                                'board_phone_1': data['board_phone_1'],
                                'total_noti': data['total_noti'],
                              });
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: data['total_noti'] == null
                            ? SizedBox(
                                height: 2.0,
                              )
                            : data['total_noti'] == 0
                                ? SizedBox(
                                    height: 2.0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 10,
                                    child: Text(
                                      data['total_noti'].toString(),
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
                    backgroundColor: nbtn4 == true
                        ? Colors.white54
                        : hexToColor("#" + template_kNavigationFooterBarColor),
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
                        if (loadSuccess == true) {
                          Navigator.pushNamed(context, "/coin", arguments: {
                            'member_point': data['member_point'],
                            'board_phone_1': data['board_phone_1'],
                            'total_noti': data['total_noti'],
                          });
                        }
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
    );
  }

  confrim(
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
                          _receivePointTurnOver();
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
}
