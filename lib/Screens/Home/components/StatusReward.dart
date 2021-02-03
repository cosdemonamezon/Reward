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
  SharedPreferences prefs;
  bool isLoading = false;
  List<dynamic> data = [];

  @override
  void initState() { 
    super.initState();
    _getlogGroupMember();
  }

  _getlogGroupMember() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //print(token);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI +'api/getlogGroupMember';
   
    var response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'token': token['token']
      },
      body: convert.jsonEncode({
        'member_id': token['member_id']
      })
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> statusdata = convert.jsonDecode(response.body);
      if (statusdata['code'] == "200") {
        setState(() {
          data = statusdata['data'];
        });
        print(data);
      }else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${response.statusCode}');
      }
    }
    else{
      print(response.statusCode);
      //final Map<String, dynamic> coindata = convert.jsonDecode(response.body);
      Alert(
        context: context,
        type: AlertType.error,
        title: "มีข้อผิดพลาด",
        desc: response.statusCode.toString(),
        buttons: [
          DialogButton(
            child: Text(
              "ล็อกอินใหม่",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
            },
          ),
        ]
      ).show();
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
        title: Text("Status Group Reward"),
      ),
      body: Container(
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                Card(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/images/gold.JPG")
                                    )
                                )
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Member ID : ${data[index]['member_id']}',
                                  style: TextStyle (
                                      color: Colors.white,
                                      fontSize: 13.5
                                  ),
                                ),
                                Text('Old Group : ${data[index]['old_group']}',
                                  style: TextStyle (
                                      color: Colors.white,
                                      fontSize: 13.5
                                  ),
                                ),
                                Text('Update By : ${data[index]['updated_by']}',
                                  style: TextStyle (
                                      color: Colors.white,
                                      fontSize: 13.5
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${data[index]['date']}',
                              style: TextStyle (
                                color: Colors.white,
                                fontSize: 11.5
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: data.length
        ),
      ),
    );
  }
}