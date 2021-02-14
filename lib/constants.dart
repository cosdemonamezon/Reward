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
//String pathAPI = "http://103.74.253.96/reward-api/public/";
String pathAPI = "https://mzreward.com/reward-api/public/";
String pathRegister = "https://mzreward.com/";

//เซ็ทตัวแปร ตรง bottomNavigationBar
String notinum = "";
bool nbtn1 = false;
bool nbtn2 = false;
bool nbtn3 = false;
bool nbtn4 = false;

//ใช้กับ custom_dialog
String picSuccess = "assets/images/success.png";
String picDenied = "assets/images/denied.png";
String picWanning = "assets/images/wanning.png";
String headtitle = "มีข้อผิดพลาดในระบบ";
String errPhone = "โปรดตรวจสอบหมายเลขโทรศัพท์อีกครั้ง";
String confrimpoint = "ยืนยันโอน Point";
String errorProfile ="ไม่สำร็จ เกิดข้อผิดพลาดในระบบ";
String checkData = "กรุณาตรวจสอบข้อมูลอีกครั้ง";
String aertLogin = "กรุณาล็อกอินก่อน";
String settitle = "ไม่สามารถทำรายการได้";
String comfirmUse = "โปรดยืนยัน User Name ก่อนทำรายการ";
String noService = "ยังไม่เปิดให้บริการ";
class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

dialog1 (String title, context)  {
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
              Text(title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text("กลับไปล็อกอินใหม่",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
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
                  color: Colors.lightBlueAccent,
                  child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 18)),
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
              child: Image.asset("assets/images/model.jpeg")
            ),
          ),
        ),
      ],
    ),
  );
}

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
              Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(subtitle,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF01579B),
                  child: Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 18)),
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
          ),
        ),
      ],
    ),
  );
}

dialogHome (String title, String img, context) {
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
          ),
        ),
      ],
    ),
  );
}

dialogConfrim(String title, String img, context,){
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(12),
                        color: Color(0xFFD50000),
                        child: Text('ยกเลิก', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
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

errorPopup(String title, String img, context){
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
                    Navigator.pop(context);
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

dialogAlert (String title,String img, context)  {
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
              Text(title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),              
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.red,
                  child: Text('ปิด', style: TextStyle(color: Colors.white, fontSize: 18)),
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




  




