import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/constants.dart';

class DetailNoti extends StatefulWidget {
  DetailNoti({Key key}) : super(key: key);

  @override
  _DetailNotiState createState() => _DetailNotiState();
}

class _DetailNotiState extends State<DetailNoti> {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    //print(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#" + template_kNavigationBarColor),
        leading: IconButton(
          onPressed: () {
            //Navigator.pushNamedAndRemoveUntil(context, "/noti", (route) => false);
            //Navigator.pop(context);
            //Navigator.of(context).pop();
            Navigator.pushNamed(context, "/noti", arguments: {
              'member_point': data['member_point'],
              'board_phone_1': data['board_phone_1'],
              'total_noti': data['total_noti'],
            });
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Detail Nitification"),
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.70,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (data['url'] != null) {
                    launch(data['url']);
                  } else {
                    print("No Url");
                  }
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: data['pic'] != null
                      ? Image.network(
                          data['pic'],
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          'https://picsum.photos/400/200',
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  data['created_at'] != null
                      ? Text(data['created_at'])
                      : Text("........."),
                ],
              ),
              ListTile(
                title: data['title'] != null
                    ? Text(data['title'])
                    : Text("ไม่มีข้อมูล..."),
                subtitle: data['description'] != null
                    ? Text(data['description'])
                    : Text("ไม่มีข้อมูล..."),
              ),
            ],
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
                    backgroundColor:
                        hexToColor("#" + template_kNavigationFooterBarColor),
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
    );
  }
}
