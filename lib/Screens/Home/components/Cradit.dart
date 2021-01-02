import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';

class Cradit extends StatefulWidget {
  Cradit({Key key}) : super(key: key);

  @override
  _CraditState createState() => _CraditState();
}

class _CraditState extends State<Cradit> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getRewardMember();
    tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    print(data);
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
        toolbarHeight: 120,
        //backgroundColor: Colors.grey,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: Icon(Icons.account_circle, size: 38,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    "ยอดเครดิต ${data['credit']}", 
                    style: TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ข้อมูล ณ เวลา 06:04",
                  style: TextStyle(color: kTextColor, fontSize: 12.0, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          indicatorWeight: 5.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: "ข้อมูลเครดิต",),
            Tab(text: "รายการ",),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          //Tab ที่หนึ่ง
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ถอนเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            Text("500,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:54 น.", style: TextStyle(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ฝากเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            Text("200,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:54 น.", style: TextStyle(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),

          //Tab ที่สอง
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Text(
                  "รายการล่าสุด",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,),
                child: Text("4 ส.ค. 63"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ถอนเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            Text("500,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:54 น.", style: TextStyle(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ฝากเงิน", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            Text("200,000 บาท", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:54 น.", style: TextStyle(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                  CircleAvatar(
                    backgroundImage: AssetImage(pathicon3),
                    radius: 24,
                    child: GestureDetector(
                      onTap: (){},
                    ),
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