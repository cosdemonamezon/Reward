import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.grey,
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
                    "ยอดเครดิต 2,924", 
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
            Tab(text: "xxxxx",),
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
                Text("data"),
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
      )
    );
  }
}