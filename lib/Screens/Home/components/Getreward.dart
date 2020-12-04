import 'package:flutter/material.dart';

class GetReward extends StatefulWidget {
  GetReward({Key key}) : super(key: key);

  @override
  _GetRewardState createState() => _GetRewardState();
}

class _GetRewardState extends State<GetReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รับรางวัล"),
      ),
    );
  }
}