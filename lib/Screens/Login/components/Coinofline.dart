import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Helpofline.dart';
import 'package:Reward/Screens/Login/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coineofline extends StatefulWidget {
  Coineofline({Key key}) : super(key: key);

  @override
  _CoineoflineState createState() => _CoineoflineState();
}

class _CoineoflineState extends State<Coineofline> {
  bool isLoading = false;
  List<dynamic> coin = [];
  Map<String, dynamic> numberNoti = {};
  String checkToken = "";
  SharedPreferences prefs;
  // String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  @override
  void initState() {
    super.initState();
    _getDetailReward();
  }

  _getDetailReward() async {
    // prefs = await SharedPreferences.getInstance();
    // var tokenString = prefs.getString('token');
    // var token = convert.jsonDecode(tokenString);

    // setState(() {
    //   template_kNavigationBarColor = token['color']['color_1'];
    //   template_kNavigationFooterBarColor = token['color']['color_2'];
    // });

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getDetailPoint';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'token': token['token']
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
      if (coindata['code'] == "200") {
        setState(() {
          coin = coindata['data'];
          setState(() {
            isLoading = false;
          });
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
      // print(response.statusCode);
      // final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }),
            );
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Coin"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : coin.length == 0
              ? Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                )
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/webview',
                                arguments: {
                                  'title': coin[index]['title'],
                                  'url': coin[index]['url']
                                });
                            // var url = coin[index]['url'];
                            // launch((url));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200.0,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: coin[index]['pic'] != null
                                          ? Image.network(
                                              coin[index]['pic'],
                                              fit: BoxFit.fill,
                                            )
                                          : Ink.image(
                                              image: AssetImage(
                                                  "assets/images/r1.jpg"),
                                              fit: BoxFit.cover),
                                      // Ink.image(
                                      //   image: NetworkImage('https://picsum.photos/400/200'),
                                      //   fit: BoxFit.cover
                                      // ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      left: 15.0,
                                      child: Text(
                                        coin[index]['No'].toString(),
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coin[index]['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      coin[index]['description'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: coin.length),
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
          padding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 15.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: kNavigationBarColor,
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
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => dialogAlert(
                            aertLogin,
                            picDenied,
                            context,
                          ),
                        );
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
                    backgroundColor: kNavigationBarColor,
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
                        //Navigator.pushNamed(context, "/help",);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Helpofline();
                          }),
                        );
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
                        backgroundColor: kNavigationBarColor,
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
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => dialogAlert(
                                aertLogin,
                                picDenied,
                                context,
                              ),
                            );
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
                    backgroundColor: kNavigationBarColor,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Coineofline();
                          }),
                        );
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
}
