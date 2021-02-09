import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailNoti extends StatefulWidget {
  DetailNoti({Key key}) : super(key: key);

  @override
  _DetailNotiState createState() => _DetailNotiState();
}

class _DetailNotiState extends State<DetailNoti> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            //Navigator.pushNamedAndRemoveUntil(context, "/noti", (route) => false);
            //Navigator.pop(context);
            //Navigator.of(context).pop();
            Navigator.pushNamed(context, "/noti", arguments: {
              'member_point': data['member_point'],
              'board_phone_1': data['board_phone_1'],
              'total_noti': data['total_noti'],
            });
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Detail Nitification"),
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.70,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  if (data['url'] != null) {
                    launch(data['url']);
                  } else {
                    print("No Url");
                  }                  
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: data['pic'] != null ? Image.network(data['pic'], fit: BoxFit.fill,)
                  : Image.network('https://picsum.photos/400/200', fit: BoxFit.fill,),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  data['created_at'] != null ? Text(data['created_at'])
                  :Text("........."),
                ],
              ),
              ListTile(
                title: data['title'] != null ? Text(data['title'])
                :Text("ไม่มีข้อมูล..."),
                subtitle: data['description'] != null ? Text(data['description'])
                :Text("ไม่มีข้อมูล..."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}