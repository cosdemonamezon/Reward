import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Reward/Screens/Login/components/Coinofline.dart';
import 'package:Reward/Screens/Login/LoginScreen.dart';

class Helpofline extends StatefulWidget {
  Helpofline({Key key}) : super(key: key);

  @override
  _HelpoflineState createState() => _HelpoflineState();
}

class _HelpoflineState extends State<Helpofline> {
  bool isLoading = false;
  List<dynamic> help = [];  
  Map<String, dynamic> numberNoti = {};
  String checkToken = "";

  @override
  void initState() { 
    super.initState();
    _getDetailPoint();
  }

  _getDetailPoint()async{
    setState(() {
      isLoading = true;
      
    });
    var url = pathAPI +'api/getDetailPoint';
    var response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        //'token': token['token']
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
          setState(() {
            isLoading = false;
          });
          // print("รอบแรก");
          // print(help[0]['description']);
        });
      }
      else {
        String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
        showDialog(
          context: context,
          builder: (context) => dialogDenied(
            title, picDenied, context,
          ),
        ); 
      }
    }
    else{
      // print(response.statusCode);
      // final Map<String, dynamic> helpdata = convert.jsonDecode(response.body);
      String title = "ข้อผิดพลาดภายในเซิร์ฟเวอร์";
      showDialog(
        context: context,
        builder: (context) => dialogDenied(
          title, picDenied, context,
        ),
      ); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context){return LoginScreen();}
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Help Advice"),
      ),
      body: isLoading == true ? 
      Center(
        child: CircularProgressIndicator(),
      )
      :help.length == 0 ?
      Center(
        child: Text(
          "ไม่พบข้อมูล", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      )
      :ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Card(
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/webview', arguments: {                    
                    'title': help[index]['title'],
                    'url': help[index]['url']
                  });
                  // var url = help[index]['url'];
                  // launch((url));
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
                            : 
                            Ink.image(
                              image: AssetImage("assets/images/p1.jpg"),
                              fit: BoxFit.cover
                            ),
                            // Ink.image(image: NetworkImage('https://picsum.photos/400/200'), fit: BoxFit.cover),
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
                    foregroundColor: nbtn1 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = true;
                          nbtn2 = false;
                          nbtn3 = false;
                          nbtn4 = false;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => dialogAlert(
                            aertLogin, picDenied, context,
                          ),
                        ); 
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
                    foregroundColor: nbtn2 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon2),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = false;
                          nbtn2 = true;
                          nbtn3 = false;
                          nbtn4 = false;
                        });
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Helpofline();}
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
                        foregroundColor: nbtn3 == true ? Colors.red : Colors.white,
                        backgroundImage: AssetImage(pathicon3),
                        radius: 24,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              nbtn1 = false;
                              nbtn2 = false;
                              nbtn3 = true;
                              nbtn4 = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => dialogAlert(
                                aertLogin, picDenied, context,
                              ),
                            ); 
                          },
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        //top: 2.0,
                        child: numberNoti['total_noti'] == null ? SizedBox(height: 2.0,)
                        :numberNoti['total_noti'] == 0 ? SizedBox(height: 2.0,)
                        :CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                           numberNoti['total_noti'].toString(),
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
                    foregroundColor: nbtn4 == true ? Colors.red : Colors.white,
                    backgroundImage: AssetImage(pathicon4),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          nbtn1 = false;
                          nbtn2 = false;
                          nbtn3 = false;
                          nbtn4 = true;
                        });
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context){return Coineofline();}
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