import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailReward extends StatefulWidget {
  DetailReward({Key key}) : super(key: key);

  @override
  _DetailRewardState createState() => _DetailRewardState();
}

class _DetailRewardState extends State<DetailReward> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    print(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Reward"),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "โปรโมชั่นแลกของวันนี้",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${data['title']}",
                  style: TextStyle(fontSize: 16.0,),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(),
                child: Image.network(data['pic'], fit: BoxFit.cover,),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${data['description']}",
                  style: TextStyle(fontSize: 15.0,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "คะแนน ${data['point']} Point",
                  style: TextStyle(fontSize: 15.0,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "แลกรางวัล", 
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [                            
                              Colors.grey[50],
                              Colors.greenAccent,
                              Colors.greenAccent, 
                              Colors.greenAccent,
                              Colors.grey[50],
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("แต้มไม่พอ"),
              ),
              GestureDetector(
                onTap: (){
                  var url = data['url'];
                  launch((url));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("LINK ==> ${data['url']}"),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}