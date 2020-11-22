import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';

class StatusReward extends StatefulWidget {
  StatusReward({Key key}) : super(key: key);

  @override
  _StatusRewardState createState() => _StatusRewardState();
}

class _StatusRewardState extends State<StatusReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Status Reward"),
      ),
    );
  }
}