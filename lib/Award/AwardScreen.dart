import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';

class AwardScreen extends StatefulWidget {
  AwardScreen({Key key}) : super(key: key);

  @override
  _AwardScreenState createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  Map<String, dynamic> shareLink = {};
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShareLinkReward();
  }
  _getShareLinkReward() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = pathAPI +'api/getShareLinkReward';
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
      final Map<String, dynamic> shareLinkdata = convert.jsonDecode(response.body);
      if (shareLinkdata['code'] == "200") {
        print(shareLinkdata['massage']);
        setState((){
          shareLink = shareLinkdata['data'];
          //print(shareLink);
          //print(shareLink['pic']);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }else{
      print(response.statusCode);
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
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
        title: Text("แชร์ลิ้ง"),
      ),
      body: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.0,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: shareLink['pic'] != null ?
                        Image.network(shareLink['pic'], fit: BoxFit.fill,)
                        :Ink.image(image: NetworkImage('https://picsum.photos/400/200'), fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 10,
                        left: 15,
                        child: Icon(Icons.share, size: 40.0, color: Colors.blue,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        shareLink['title'] == null ? "ไม่มีข้อมูล" :shareLink['title'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        shareLink['description'] == null ? "ไม่มีข้อมูล" :shareLink['description'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              launch(('${shareLink['url']}'));     
            },
            child: Container(
              height: 50.0,
              width: 140.0,
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
                  "แชร์ลิ้ง", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}