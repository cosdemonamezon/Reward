import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class Coin extends StatefulWidget {
  Coin({Key key}) : super(key: key);

  @override
  _CoinState createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  bool isLoading = false;
  List<dynamic> coin = [];
  SharedPreferences prefs;
  String picUrlimages = "http://103.74.253.96/reward-api/public/images/detail_reward/";

  @override
  void initState() { 
    super.initState();
    _getDetailReward();
  }

  _getDetailReward()async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });

    var url = pathAPI +'api/getDetailReward';
    var response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
      if (coindata['code'] == "200") {
        setState(() {
          coin = coindata['data'];
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
      final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: coindata['massage'],
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
        title: Text("Coin"),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Card(
              child: InkWell(
                onTap: (){
                  var url = coin[index]['url'];
                  launch((url));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200.0,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: coin[index]['pic'] != null ?
                            Image.network(coin[index]['pic'], fit: BoxFit.fill,)
                            :
                            Ink.image(
                              image: AssetImage("assets/images/r1.jpg"),
                              fit: BoxFit.cover
                            ), 
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
                                color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 25.0,
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            coin[index]['description'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
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
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: coin.length
      ),
    );
  }
}