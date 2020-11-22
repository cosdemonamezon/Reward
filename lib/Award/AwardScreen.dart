import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';

class AwardScreen extends StatefulWidget {
  AwardScreen({Key key}) : super(key: key);

  @override
  _AwardScreenState createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/home.jpg", fit: BoxFit.cover,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.7),
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/qr.png"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
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
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      Text("https://www.aschaaschaascha.com"),
                                      //Icon(Icons.copy_rounded)
                                      IconButton(
                                        icon: Icon(Icons.copy_rounded),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      Text("https://www.aschaaschaascha.com"),
                                      IconButton(
                                        icon: Icon(Icons.copy_rounded),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      Text("https://www.aschaaschaascha.com"),
                                      IconButton(
                                        icon: Icon(Icons.copy_rounded),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  // decoration: BoxDecoration(
                                  //   border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.person_add_alt_1_rounded),
                                      Text("https://www.aschaaschaascha.com"),
                                      IconButton(
                                        icon: Icon(Icons.copy_rounded),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}