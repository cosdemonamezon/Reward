import 'package:Reward/Screens/Home/HomeScreen.dart';
import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Profilesettings extends StatefulWidget {
  Profilesettings({Key key}) : super(key: key);

  @override
  _ProfilesettingsState createState() => _ProfilesettingsState();
}

class _ProfilesettingsState extends State<Profilesettings> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool active = false;

  @override
  void initState(){
    super.initState();
    _getActive();
  }

  _getActive(){
    active = true;
    //initState();
  }
  

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    print(data);
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
          active == false ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.0,),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Profile Setting", style: TextStyle(color: kTextColor, fontSize: 40.0),),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
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
                                  child: TextField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: "username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: TextField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: "username หลังจาก call api เขา",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: TextField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: "ตัวย่อกระดาน",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                  ),
                                  child: TextField(
                                    maxLines: 5,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: "ที่อยู่",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50.0,
                                        width: 100,
                                        margin: EdgeInsets.symmetric(horizontal: 40),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.orange[900],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "ยกเลิก"
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        //_getActive();
                                        setState(() {
                                          active = true;
                                        });
                                      },
                                      child: Container(
                                        height: 50.0,
                                        width: 100,
                                        margin: EdgeInsets.symmetric(horizontal: 40),
                                        decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(50),
                                          color: Colors.green[400],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "บันทึก"
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.0,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
          )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.0,),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("ยืนยัน สมาชิก", style: TextStyle(color: kTextColor, fontSize: 40.0),),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          FormBuilder(
                            key: _fbKey,
                            initialValue: {
                              'address': data['member_address']
                            },
                            child: Container(
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Name th",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Name en",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Email Address",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200])),
                                    ),
                                    child: FormBuilderTextField(
                                      attribute: 'address',
                                      maxLines: 5,
                                      autofocus: false,
                                      decoration: InputDecoration(                                        
                                        hintText: "Address",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 25.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(50),
                                            color: Colors.orange[900],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "ยกเลิก"
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          //_getActive();
                                          setState(() {
                                            active = false;
                                          });
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 100,
                                          margin: EdgeInsets.symmetric(horizontal: 40),
                                          decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(50),
                                            color: Colors.green[400],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "บันทึก"
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ),
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
        ],
      ),
    );
  }
}