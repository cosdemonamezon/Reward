import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Helpadvice extends StatefulWidget {
  Helpadvice({Key key}) : super(key: key);

  @override
  _HelpadviceState createState() => _HelpadviceState();
}

class _HelpadviceState extends State<Helpadvice> {
  bool isLoading = false;
  List<dynamic> help = [];
  SharedPreferences prefs;
  String picUrlimages = "http://103.74.253.96/reward-api/public/images/detail_point/";

  @override
  void initState() { 
    super.initState();
    _getDetailPoint();
  }

  _getDetailPoint() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getDetailPoint';
    var response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      // body: convert.jsonEncode({
      //   'member_id': token['member_id']
      // })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> helpdata = convert.jsonDecode(response.body);
      if(helpdata['code'] == "200"){
        //print(helpdata['massage']);
        setState((){
          help = helpdata['data'];
          // print("รอบแรก");
          // print(help[0]['description']);
        });
      }
      else {
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
        title: Text("Help Advice"),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Card(
              child: InkWell(
                onTap: (){
                  var url = help[index]['url'];
                  launch((url));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200.0,
                      //color: Colors.redAccent,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: help[index]['pic'] != null ?
                            Image.network(help[index]['pic'], fit: BoxFit.fill,)
                            : Ink.image(image: NetworkImage('https://picsum.photos/400/200'), fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 10,
                            left: 15,
                            child: Text(
                              help[index]['No'].toString(),
                              style: TextStyle(
                                color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 25.0
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
                            help[index]['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            help[index]['description'],
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
        itemCount: help.length
      ),
    );
  }
}