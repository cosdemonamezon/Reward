import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kPrimarybackgroundColor = Color(0xFFFFFFFF);
const kThemeColor = Color(0xFF01579B);
const kTextColor = Color(0xFFFFFFFF);
const kNavigationBarColor = Color(0xFF01579B);

//edit icon navigationBar
String pathicon1 = "assets/images/telephone.png";
String pathicon2 = "assets/images/info.jpg";
String pathicon3 = "assets/images/noti.jpg";
String pathicon4 = "assets/images/star.jpg";

//Path API
//String pathAPI = "https://mzreward.com/reward-api/public/";
String pathAPI = "https://mzreward.com/reward-api/public/";

//เซ็ทตัวแปร ตรง bottomNavigationBar
String notinum = "";
bool nbtn1 = false;
bool nbtn2 = false;
bool nbtn3 = false;
bool nbtn4 = false;

//ใช้กับ custom_dialog
<<<<<<< HEAD
class Constants {
=======
String picSuccess = "assets/images/success.png";
String picDenied = "assets/images/denied.png";
String picWanning = "assets/images/wanning.png";
String headtitle = "มีข้อผิดพลาดในระบบ";
String errPhone = "โปรดตรวจสอบหมายเลขโทรศัพท์อีกครั้ง";
String confrimpoint = "ยืนยันโอน Point";
String errorProfile ="ไม่สำร็จ เกิดข้อผิดพลาดในระบบ";
String checkData = "กรุณาตรวจสอบข้อมูลอีกครั้ง";
class Constants{
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

<<<<<<< HEAD
dialog1(String title, context) async {
=======
dialog1 (String title, context)  {
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "กลับไปล็อกอินใหม่",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/loginScreen',
                        (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.lightBlueAccent,
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/images/model.jpeg")),
          ),
        ),
      ],
    ),
  );
}

<<<<<<< HEAD
dialog2(String title, String subtitle, context) async {
=======
dialogDenied (String title, String img, context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 20,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Constants.padding,top: Constants.avatarRadius
            + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
            ),]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),              
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Image.asset(img)
            ),
          ),
        ),
      ],
    ),
  );
}

errordialog (String title, String subtitle, String img, context)  {
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
<<<<<<< HEAD
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "กลับไปล็อกอินใหม่",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
=======
              Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(subtitle,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
<<<<<<< HEAD
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/loginScreen',
                        (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.lightBlueAccent,
                  child: Text('ตกลง',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
=======
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 18)),
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
<<<<<<< HEAD
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/images/model.jpeg")),
=======
              borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Image.asset(img)
            ),
          ),
        ),
      ],
    ),
  );
}

successdialog(String title, String img, context){
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 4,
    backgroundColor: Colors.transparent,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Constants.padding,top: Constants.avatarRadius
            + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
            ),]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),              
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Image.asset(img)
            ),
>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
          ),
        ),
      ],
    ),
  );
}
<<<<<<< HEAD
=======


  




>>>>>>> a88d87985ec614998aeb1a0230fd0f493a1c636c
