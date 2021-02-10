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
  String picUrlimages = "http://103.74.253.96/reward-api/public/images/campaign/";
  String type1 = "News";
  String type2 = "Promotion";
  final scrollController = ScrollController(initialScrollOffset: 0);

  @override
  void initState() { 
    super.initState();
    _getBannerM();
    _getCampaignMember();
    
  }

  _getBannerM() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI +'api/getBannerM';
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'banner_type': type1
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> bannerType = convert.jsonDecode(response.body);
      if(bannerType['code'] == "200"){
        print(bannerType['massage']);
        setState((){
          banner = bannerType['data'];
          print(banner);
        });
      }else{
        print('error from backend ${response.statusCode}');
      }

    }else{
      print(response.statusCode);
    }
  }

  _getCampaignMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getCampaignMember';
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
      final Map<String, dynamic> campaigndata = convert.jsonDecode(response.body);
      if(campaigndata['code'] == "200"){
        print(campaigndata['massage']);
        setState((){
          campaign = campaigndata['data'];
          //print(campaign);
        });
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }
    else{
      print(response.statusCode);
      final Map<String, dynamic> campaigndata = convert.jsonDecode(response.body);
      Alert(
          context: context,
          type: AlertType.error,
          title: "มีข้อผิดพลาด",
          desc: campaigndata['massage'],
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


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

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
        title: Text("โปรโมชั่น"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 170,
                child: Expanded(
                  child: Swiper(                    
                    itemBuilder: (context, index){
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: banner[index]['banner_pic'] != null ?
                            Image.network(banner[index]['banner_pic'], fit: BoxFit.cover,)
                            : Image.network('https://picsum.photos/400/200', fit: BoxFit.cover,),
                          ),                         
                          
                          // Positioned(
                          //   top: 30,
                          //   left: 10,
                          //   child: Text(
                          //     banner[index]['banner_name'],
                          //     style: TextStyle(
                          //       color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 20.0
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
                    },                   
                    autoplay: true,
                    itemCount: banner.length,
                    pagination: SwiperPagination(),
                    controller: SwiperController(),
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Stack(
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
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200])),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage("assets/images/gold.JPG"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "User Member : ${data['username']}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              SizedBox(height: 10.0,),
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
                          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: (){
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Image.asset("assets/images/124.JPG"),
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        child: campaign[index]['pic'] != null ? 
                                        Image.network(campaign[index]['pic'], fit: BoxFit.fill,) :
                                        Image.network('https://picsum.photos/400/200', fit: BoxFit.fill,),
                                      ),
                                      SizedBox(height: 5,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          campaign[index]['title'],
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: (){
                                    if (campaign[index]['status'] == true) {
                                      var url = campaign[index]['url'];
                                      launch((url));
                                    } else {
                                    }
                                    
                                  },
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: campaign[index]['status'] == false ? Color(0xFFF001117).withOpacity(0.4) : Color(0xFFFFFFFFF).withOpacity(0.1),
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