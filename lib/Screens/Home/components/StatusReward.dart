import 'package:flutter/material.dart';
import 'package:Reward/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusReward extends StatefulWidget {
  StatusReward({Key key}) : super(key: key);

  @override
  _StatusRewardState createState() => _StatusRewardState();
}

class _StatusRewardState extends State<StatusReward> {
  bool isLoading = false;
  List<dynamic> help = [];
  SharedPreferences prefs;

  @override
  void initState() { 
    super.initState();
    _getlogGroupMember();
  }

  _getlogGroupMember() async{

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
        title: Text("Status Reward"),
      ),
    );
  }
}