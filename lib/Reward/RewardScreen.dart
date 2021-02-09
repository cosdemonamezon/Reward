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

class _RewardScreenState extends State<RewardScreen> with SingleTickerProviderStateMixin {
  TabController tabController;
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> reward = [];
  List<dynamic> transreward = [];
  String picUrlimages = pathAPI +"images/reward/";
  String btn1 = 'Approved';
  String btn2 = 'Hide For Review';
  String btn3 = 'Reject';
  bool abtn1 = true;
  bool abtn2 = false;
  bool abtn3 = false;
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

  _getRewardMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getRewardMember';
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

    if (response.statusCode == 200){
      final Map<String, dynamic> rewarddata = convert.jsonDecode(response.body);
      if(rewarddata['code'] == "200"){
        //print(rewarddata['massage']);
        setState((){
          reward = rewarddata['data'];
          //print(reward);
        });
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }

    }else {
      print("error");
      print(response.statusCode);
      final Map<String, dynamic> rewarddata = convert.jsonDecode(response.body);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: rewarddata['massage'],
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

  _getlogTransRewardMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getlogTransRewardMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'reward_status': btn1
      })
    );

    if (response.statusCode == 200){
      final Map<String, dynamic> transrewarddata = convert.jsonDecode(response.body);
      if(transrewarddata['code'] == "200"){
        print(transrewarddata['massage']);
        setState((){
          transreward = transrewarddata['data'];
          //print(transreward);
        });
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }
    else {
      print("error1");
      print(response.statusCode);
      final Map<String, dynamic> transrewarddata = convert.jsonDecode(response.body);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: transrewarddata['massage'],
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

  _getApproved() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getlogTransRewardMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'reward_status': btn1
      })
    );

    if (response.statusCode == 200){
      final Map<String, dynamic> transrewarddata = convert.jsonDecode(response.body);
      if(transrewarddata['code'] == "200"){
        //print(transrewarddata['massage']);
        setState((){
          transreward = transrewarddata['data'];
          //print(transreward);
          
          //initState();
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
  }
}

_getReject() async {
  prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
  
  setState(() {
      isLoading = true;
    });

  var url = pathAPI +'api/getlogTransRewardMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'reward_status': btn3
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> transrewarddata = convert.jsonDecode(response.body);
      if(transrewarddata['code'] == "200"){
        //print(transrewarddata['massage']);
        setState((){
          transreward = transrewarddata['data'];
          //print(transreward);
          
          //initState();
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
  }
}

_getHideForReview() async{
  prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
  
  setState(() {
    isLoading = true;
  });
  var url = pathAPI +'api/getlogTransRewardMember';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id'],
        'reward_status': btn2
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> transrewarddata = convert.jsonDecode(response.body);
      if(transrewarddata['code'] == "200"){
        //print(transrewarddata['massage']);
        setState((){
          transreward = transrewarddata['data'];
          //print(transreward);
          
          //initState();
        });
        //initState();
        //print("ได้ข้อมูลนะ");
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }
}

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    //print(data);
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
        title: Text("Reward"),
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          indicatorWeight: 5.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
          Tab(child: Text("MEMBER"),),
          Tab(child: Text("รายละเอียด"),),
        ]),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          //Tab ที่หนึ่ง
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Stack(
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
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200])),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/images/gold.JPG"),
                                radius: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              //child: Text("User Member : User XXXX9528"),
                              child: Text("User Member : ${data['username']}"),
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
                    height: 10,
                    child: GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      //mainAxisSpacing: 2,
                      children: List.generate(reward.length, (index) {
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                            child: GestureDetector(
                              onTap: (){
                                // var url = reward[index]['url'];
                                // launch((url));
                                Navigator.pushNamed(context, '/detailreward', arguments: {
                                  'id': reward[index]['id'],
                                  'title': reward[index]['title'],
                                  'description': reward[index]['description'],
                                  'url': reward[index]['url'],
                                  'pic': reward[index]['pic'],
                                  'point': reward[index]['point'],
                                  'transfer_status': reward[index]['transfer_status'],
                                  'group_status': reward[index]['group_status'],
                                  'qty_status': reward[index]['qty_status'],
                                  'member_id': data['member_id'],
                                  'member_point': data['member_point'],
                                });
                              },
                              child: Card(
                                elevation: 10.0,
                                //color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Image.asset("assets/images/124.JPG"),
                                    //Ink.image(image: NetworkImage(picUrlimages+reward[index]['pic']), fit: BoxFit.cover),
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      child: reward[index]['pic'] != null ?
                                      Image.network(reward[index]['pic'], fit: BoxFit.fill,) :
                                      Image.network('https://picsum.photos/400/200', fit: BoxFit.fill,),
                                    ),
                                    //Image.network(picUrlimages+reward[index]['pic'], fit: BoxFit.cover,),
                                    SizedBox(height: 2,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        reward[index]['description'],
                                        style: TextStyle(fontSize: 12.0),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // Chip(
                                          //   backgroundColor: Colors.blueAccent,
                                          //   elevation: 2.0,
                                          //   label: Text("point"),
                                          // ),
                                          Icon(Icons.star),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 3.0),
                                            child: Text(reward[index]['point'].toString()),
                                          ),
                                          Text("P"),
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
                        onTap: (){                          
                          setState(() {
                            abtn1 = true;
                            abtn2 = false;
                            abtn3 = false;
                          });
                          _getApproved();
                        },
                        child: abtn1 == true ? Container(
                          height: 50.0,
                          width: 100,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[900],
                          ),
                          child: Center(
                            child: Text(
                              "Approved", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.white),
                            ),
                          ),
                        ):
                        Container(
                          height: 50.0,
                          width: 100,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          child: Center(
                            child: Text(
                              "Approved", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.black),
                            ),
                          ),
                        )
                      ),

                      GestureDetector(
                        onTap: (){
                          //_getlogTransRewardMember();
                          setState(() {
                            abtn1 = false;
                            abtn2 = true;
                            abtn3 = false;
                          });
                          _getHideForReview();
                        },
                        child: abtn2 == true ? Container(
                          height: 50.0,
                          width: 150,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[900],
                          ),
                          child: Center(
                            child: Text(
                              "Hide For Review",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.white),
                            ),
                          ),
                        ):
                        Container(
                          height: 50.0,
                          width: 150,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          child: Center(
                            child: Text(
                              "Hide For Review",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.black),
                            ),
                          ),
                        )
                      ),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            abtn1 = false;
                            abtn2 = false;
                            abtn3 = true;
                          });
                          _getReject();
                        },
                        child: abtn3 == true ? Container(
                          height: 50.0,
                          width: 100,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[900],
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.white),
                            ),
                          ),
                        ):
                        Container(
                          height: 50.0,
                          width: 100,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.6, color: Colors.black),
                            ),
                          ),
                        )
                      ),
                      
                    ],
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: transreward.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        child: transreward[index]['pic'] != null ?
                                          Image.network(transreward[index]['pic'], fit: BoxFit.fill,) :
                                          Image.network('https://picsum.photos/400/200', fit: BoxFit.fill,),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transreward[index]['title'], 
                                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                            ),
                                            Text(
                                              transreward[index]['description'].length <= 41 ? transreward[index]['description'] : transreward[index]['description'].substring(0, 41), 
                                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  transreward[index]['point'].toString(),
                                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Text(
                                                    "Point",
                                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text("ถอนเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                  // Text("500,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  transreward[index]['appove_status'] == "Approved" ?
                                  Chip(
                                    backgroundColor: Colors.greenAccent,
                                    label: Text(
                                      transreward[index]['appove_status'], 
                                      style: TextStyle(fontSize: 12.0)
                                    ),
                                  )
                                  : transreward[index]['appove_status'] == "Reject" ? 
                                  Chip(
                                    backgroundColor: Colors.redAccent,
                                    label: Text(
                                      transreward[index]['appove_status'], 
                                      style: TextStyle(fontSize: 12.0)
                                    ),
                                  )
                                  : Chip(
                                    backgroundColor: Colors.orangeAccent,
                                    label: Text(
                                      transreward[index]['appove_status'], 
                                      style: TextStyle(fontSize: 12.0)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
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
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "/noti", arguments: {
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