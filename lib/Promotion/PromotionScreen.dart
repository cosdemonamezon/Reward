import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PromotionScreen extends StatefulWidget {
  PromotionScreen({Key key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> campaign = [];
  String picUrlimages = "http://103.74.253.96/reward-api/public/images/campaign/";

  @override
  void initState() { 
    super.initState();
    _getCampaignMember();
  }

  _getCampaignMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = 'http://103.74.253.96/reward-api/public/api/getCampaignMember';
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
    }
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/img_2.jpg"),
                    fit: BoxFit.cover,
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
                          child: GestureDetector(
                            onTap: (){
                              var url = campaign[index]['url'];
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
                                    Image.network(picUrlimages+campaign[index]['pic'], fit: BoxFit.fill,) :
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
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}