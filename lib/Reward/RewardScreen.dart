import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RewardScreen extends StatefulWidget {
  RewardScreen({Key key}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> reward = [];
  List<dynamic> transreward = [];
  String picUrlimages = pathAPI + "images/reward/";
  String btn1 = 'Approved';
  String btn2 = 'Hide For Review';
  String btn3 = 'Reject';
  bool abtn1 = true;
  bool abtn2 = false;
  bool abtn3 = false;
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  // String member_id = '';
  // String member_point = '';
  // String confrim_address_status = 'Yes';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRewardMember();
    _getlogTransRewardMember();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  _getRewardMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getRewardMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> rewarddata = convert.jsonDecode(response.body);
      if (rewarddata['code'] == "200") {
        //print(rewarddata['massage']);
        setState(() {
          reward = rewarddata['data'];
          print(reward);
          setState(() {
            isLoading = false;
          });
          //print(reward);
        });
      } else {
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
    } else {
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

  _getlogTransRewardMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getlogTransRewardMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode(
            {'reward_status': btn1}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> transrewarddata =
          convert.jsonDecode(response.body);
      if (transrewarddata['code'] == "200") {
        //print(transrewarddata['massage']);
        setState(() {
          transreward = transrewarddata['data'];
          setState(() {
            isLoading = false;
          });
          //print(transreward);
        });
      } else {
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
    } else {
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

  _getApproved() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getlogTransRewardMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode(
            {'reward_status': btn1}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> transrewarddata =
          convert.jsonDecode(response.body);
      if (transrewarddata['code'] == "200") {
        //print(transrewarddata['massage']);
        setState(() {
          transreward = transrewarddata['data'];
          setState(() {
            isLoading = false;
          });
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      } else {
        String title = "ไม่พบข้อมูล";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
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

  _getReject() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/getlogTransRewardMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode(
            {'reward_status': btn3}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> transrewarddata =
          convert.jsonDecode(response.body);
      if (transrewarddata['code'] == "200") {
        //print(transrewarddata['massage']);
        setState(() {
          transreward = transrewarddata['data'];
          setState(() {
            isLoading = false;
          });
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      } else {
        String title = "ไม่พบข้อมูล";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
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

  _getHideForReview() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getlogTransRewardMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode(
            {'reward_status': btn2}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> transrewarddata =
          convert.jsonDecode(response.body);
      if (transrewarddata['code'] == "200") {
        //print(transrewarddata['massage']);
        setState(() {
          transreward = transrewarddata['data'];
          setState(() {
            isLoading = false;
          });
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      } else {
        String title = "ไม่พบข้อมูล";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errorPopup(
            title,
            picDenied,
            context,
          ),
        );
      }
    } else {
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
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: hexToColor("#" + template_kNavigationBarColor),
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
          centerTitle: true,
          title: Text("รีวอร์ด"),
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
                  child: Text("รายการ", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ประวัติ", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          //controller: tabController,
          children: [
            //Tab ที่หนึ่ง
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : reward.length == 0
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
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(255, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 0.1),
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200])),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/gold.JPG"),
                                            radius: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          //child: Text("User Member : User XXXX9528"),
                                          child: Text(
                                              "User Member : ${data['username']}",
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              //flex: 2,
                              child: Container(
                                height: 100,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  scrollDirection: Axis.vertical,
                                  //mainAxisSpacing: 2,
                                  children: List.generate(reward.length, (index) {
                                    return Container(
                                      height: 150,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // var url = reward[index]['url'];
                                            // launch((url));
                                            Navigator.pushNamed(
                                                context, '/detailreward',
                                                arguments: {
                                                  'id': reward[index]['id'],
                                                  'title': reward[index]['title'],
                                                  'description': reward[index]
                                                      ['description'],
                                                  'url': reward[index]['url'],
                                                  'pic': reward[index]['pic'],
                                                  'point': reward[index]['point'],
                                                  'qty': reward[index]['qty'],
                                                  'date_start': reward[index]['date_start'],
                                                  'date_stop': reward[index]['date_stop'],
                                                  'transfer_status': reward[index]
                                                      ['transfer_status'],
                                                  'group_status': reward[index]
                                                      ['group_status'],
                                                  'qty_status': reward[index]
                                                      ['qty_status'],
                                                  'member_id': data['member_id'],
                                                  'member_point':
                                                      data['member_point'],
                                                });
                                          },
                                          child: Card(
                                            elevation: 10.0,
                                            //color: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Image.asset("assets/images/124.JPG"),
                                                //Ink.image(image: NetworkImage(picUrlimages+reward[index]['pic']), fit: BoxFit.cover),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  height: 100,
                                                  width: double.infinity,
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: reward[index]['pic'] !=
                                                          null
                                                      ? Image.network(
                                                          reward[index]['pic'],
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.network(
                                                          'https://picsum.photos/400/200',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 10,
                                                        left: 15,
                                                        child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        // Chip(
                                                        //   backgroundColor: Colors.blueAccent,
                                                        //   elevation: 2.0,
                                                        //   label: Text("point"),
                                                        // ),
                                                        Icon(Icons.star, size: 18, color: Colors.red),
                                                        SizedBox(width: 2,),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                  vertical: 3.0),
                                                          child: Text(reward[index]
                                                                  ['point']
                                                              .toString(),
                                                            style:
                                                            TextStyle(
                                                              fontSize: 13.0,
                                                              color: Colors.red, fontWeight: FontWeight.bold
                                                            ),
                                                        textAlign: TextAlign.justify,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Text("P", style:
                                                            TextStyle(
                                                              fontSize: 13.0,
                                                              color: Colors.red, fontWeight: FontWeight.bold
                                                            ),
                                                        textAlign: TextAlign.justify,),
                                                      
                                                    ],
                                                  ),
                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                  
                                                ),
                                                //Image.network(picUrlimages+reward[index]['pic'], fit: BoxFit.cover,),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  child: Center(
                                                    child: Text(
                                                      reward[index]['title'],
                                                      style:
                                                          TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.access_time, size: 20, color: Colors.green,),
                                                      SizedBox(width: 3,),
                                                      Text(
                                                        reward[index]['date_start'],
                                                        style: TextStyle(
                                                          fontSize: 12.0, color: Colors.green,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                      SizedBox(width: 3,),
                                                      Text(
                                                        "-",style: TextStyle(
                                                          fontSize: 12.0, color: Colors.green,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      SizedBox(width: 3,),
                                                      Text(
                                                        reward[index]['date_stop'],
                                                        style: TextStyle(
                                                          fontSize: 12.0, color: Colors.green,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "เหลือ  "+ reward[index]['qty'].toString(),
                                                        style: TextStyle(
                                                          fontSize: 12.0, color: Colors.red,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                      // SizedBox(width: 5,),
                                                      // Text(
                                                      //   reward[index]['qty'].toString(),
                                                      //   style: TextStyle(
                                                      //     fontSize: 12.0, color: Colors.red,
                                                      //     fontWeight: FontWeight.bold
                                                      //   ),
                                                      //   textAlign: TextAlign.justify,
                                                      // ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        "สิทธิ์",
                                                        style: TextStyle(
                                                          fontSize: 12.0, color: Colors.red,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

            //tab ที่สอง
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              abtn1 = true;
                              abtn2 = false;
                              abtn3 = false;
                            });
                            _getApproved();
                          },
                          child: abtn1 == true
                              ? Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexToColor(
                                        "#" + template_kNavigationFooterBarColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "อนุมัติ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[400],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "อนุมัติ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                      GestureDetector(
                          onTap: () {
                            //_getlogTransRewardMember();
                            setState(() {
                              abtn1 = false;
                              abtn2 = true;
                              abtn3 = false;
                            });
                            _getHideForReview();
                          },
                          child: abtn2 == true
                              ? Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexToColor(
                                        "#" + template_kNavigationFooterBarColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "รอดำเนินการ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[400],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "รอดำเนินการ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              abtn1 = false;
                              abtn2 = false;
                              abtn3 = true;
                            });
                            _getReject();
                          },
                          child: abtn3 == true
                              ? Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: hexToColor(
                                        "#" + template_kNavigationFooterBarColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ปฏิเสธ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  //margin: EdgeInsets.symmetric(horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[400],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ปฏิเสธ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.6,
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                    ],
                  ),
                ),
                isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : transreward.length == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 150),
                              child: Text(
                                "ไม่พบข้อมูล",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: hexToColor("#" +
                                        template_kNavigationFooterBarColor)),
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transreward.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        if (abtn1 == true || abtn2 == true || abtn3 == true) {
                                          Navigator.pushNamed(context, '/slip', arguments: {
                                            'date_appove': transreward[index]['date_appove'],
                                            'created_at': transreward[index]['created_at'],
                                            'appove_status': transreward[index]['appove_status'],
                                            'appove_by': transreward[index]['appove_by'],
                                            'reward_slip': transreward[index]['reward_slip'],
                                            'reason_cancel': transreward[index]['reason_cancel'],
                                            'member_id': data['member_id'],
                                            'member_name_en': data['member_name_en'],
                                            'member_name_th': data['member_name_th'],
                                            'member_email': data['member_email'],
                                            'member_phone': data['member_phone'],
                                            'member_point': data['member_point'],
                                            'board_phone_1': data['board_phone_1'],
                                            'total_noti': data['total_noti'],
                                          });
                                        } else {
                                        }
                                      },
                                      child: Card(
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    height: 110,
                                                    width: 80,
                                                    child: transreward[index]
                                                                ['pic'] !=
                                                            null
                                                        ? Image.network(
                                                            transreward[index]
                                                                ['pic'],
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.network(
                                                            'https://picsum.photos/400/200',
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            transreward[index]
                                                                ['title'],
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "แต้มที่ใช้แลก:   ",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "${transreward[index]['point'].toString()}  แต้ม",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("แลกเมื่อ:   ",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "${transreward[index]['created_at']}",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("สถานะ:   ",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            transreward[index][
                                                                        'appove_status'] ==
                                                                    "Approved"
                                                                ? Chip(
                                                                    backgroundColor:
                                                                        hexToColor("#" +
                                                                            template_kNavigationFooterBarColor),
                                                                    label: Text(
                                                                        transreward[
                                                                                index]
                                                                            [
                                                                            'appove_status'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0, color: Colors.white)),
                                                                  )
                                                                : transreward[index]
                                                                            [
                                                                            'appove_status'] ==
                                                                        "Reject"
                                                                    ? Chip(
                                                                        backgroundColor:
                                                                            hexToColor("#" +
                                                                                template_kNavigationFooterBarColor),
                                                                        label: Text(
                                                                            transreward[index]
                                                                                [
                                                                                'appove_status'],
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    12.0, color: Colors.white)),
                                                                      )
                                                                    : Chip(
                                                                        backgroundColor:
                                                                            hexToColor("#" +
                                                                                template_kNavigationFooterBarColor),
                                                                        label: Text(
                                                                            transreward[index]
                                                                                [
                                                                                'appove_status'],
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    12.0, color: Colors.white)),
                                                                      ),
                                                          ],
                                                        ),
                                                        abtn3 == true ? 
                                                          Row(
                                                          children: [
                                                            Text("เหตุผล:   ",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            transreward[index]['reason_cancel'] == null
                                                            ?Text("....")
                                                            :Text(
                                                               transreward[index]['reason_cancel'].length <= 30
                                                               ?transreward[index]['reason_cancel']
                                                               :transreward[index]['reason_cancel'].substring(0, 30)+"...",
                                                                style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        )
                                                        : SizedBox(height: 3,)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Text("ถอนเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                              // Text("500,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
              ],
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
                          launch(('tel://${data['board_phone_1']}'));
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
}
