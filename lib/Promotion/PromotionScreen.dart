import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromotionScreen extends StatefulWidget {
  PromotionScreen({Key key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> campaign = [];
  List<dynamic> banner = [];
  String picUrlimages =
      "https://mzreward.com/reward-api/public/images/campaign/";
  //String picUrlimages = "http://103.74.253.96/reward-api/public/images/campaign/";
  String type1 = "News";
  String type2 = "Promotion";
  final scrollController = ScrollController(initialScrollOffset: 0);
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  @override
  void initState() {
    super.initState();
    _getBannerM();
    _getCampaignMember();
  }

  _getBannerM() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    var url = pathAPI + 'api/getBannerM';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'banner_type': type1}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> bannerType = convert.jsonDecode(response.body);
      if (bannerType['code'] == "200") {
        //print(bannerType['massage']);
        //print(bannerType['massage']);
        setState(() {
          banner = bannerType['data'];
          // print(banner);
        });
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            bannerType['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      }
    } else {
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

  _getCampaignMember() async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getCampaignMember';
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token['token']},
        body: convert.jsonEncode({'member_id': token['member_id']}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> campaigndata =
          convert.jsonDecode(response.body);
      if (campaigndata['code'] == "200") {
        //print(campaigndata['massage']);
        //print(campaigndata['massage']);
        setState(() {
          campaign = campaigndata['data'];
          setState(() {
            isLoading = false;
          });
          //print(campaign);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            campaigndata['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      }
    } else {
      //print(response.statusCode);
      final Map<String, dynamic> campaigndata =
          convert.jsonDecode(response.body);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          campaigndata['massage'],
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
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
        title: Text("โปรโมชั่น"),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : campaign.length == 0
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
                  child: Column(
                    children: [
                      Container(
                        child: CarouselSlider.builder(
                            itemCount: banner.length,
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              viewportFraction: 0.9,
                              enlargeCenterPage: true,
                              initialPage: 0,

                              //scrollDirection: Axis.vertical,
                            ),
                            itemBuilder: (context, index, realIdx) {
                              // print(banner[index]['banner_pic']);
                              if (banner.length != 0) {
                                return Container(
                                  child: banner[index]['banner_pic'] != null
                                      ? Center(
                                          child: Image.network(
                                              banner[index]['banner_pic'],
                                              fit: BoxFit.cover,
                                              width: 1000))
                                      : Center(
                                          child: Image.asset(
                                              "assets/images/nopic.png"),
                                        ),
                                );
                              }
                            }),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200])),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                          AssetImage("assets/images/gold.JPG"),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                      "User Member : ${data['username']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        //flex: 2,
                        child: Container(
                          height: 10,
                          child: GridView.count(
                            crossAxisCount: 2,
                            scrollDirection: Axis.vertical,
                            //mainAxisSpacing: 2,
                            children: List.generate(campaign.length, (index) {
                              return Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 5.0),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // if (campaign[index]['status'] == true) {
                                          //   var url = campaign[index]['url'];
                                          //   launch((url));
                                          // } else {
                                          // }
                                          var url = campaign[index]['url'];
                                          print(url);
                                          launch((url));
                                        },
                                        child: Card(
                                          //color: Colors.blue,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/124.JPG"),
                                              Container(
                                                height: 100,
                                                width: double.infinity,
                                                child: campaign[index]['pic'] !=
                                                        null
                                                    ? Image.network(
                                                        campaign[index]['pic'],
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.network(
                                                        'https://picsum.photos/400/200',
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Text(
                                                  campaign[index]['title'],
                                                  style:
                                                      TextStyle(fontSize: 13.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (campaign[index]['status'] ==
                                                true) {
                                              Navigator.pushNamed(
                                                  context, '/webview',
                                                  arguments: {
                                                    'id': data['id'],
                                                    'board_phone_1': data['board_phone_1'],
                                                    'total_noti': data['total_noti'],
                                                    'title': campaign[index]
                                                        ['title'],
                                                    'url': campaign[index]
                                                        ['url']
                                                  });
                                              // var url = campaign[index]['url'];
                                              // launch((url));
                                            } else {}
                                          },
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        color:
                                            campaign[index]['status'] == false
                                                ? Color(0xFFF001117)
                                                    .withOpacity(0.4)
                                                : Color(0xFFFFFFFFF)
                                                    .withOpacity(0.1),
                                      ),
                                    ],
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
    );
  }
}
