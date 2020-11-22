import 'package:Reward/Promotion/PromotionScreen.dart';
import 'package:Reward/Screens/Home/HomeScreen.dart';
import 'package:Reward/Screens/Home/components/Points.dart';
import 'package:Reward/Screens/Login/LoginScreen.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/LoginPage.dart';
import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Reward/Reward/RewardScreen.dart';

String token;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kThemeColor,
        scaffoldBackgroundColor: kPrimarybackgroundColor,
      ),
      //home: LoginScreen(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        //'/': (context) => LoginScreen(),
        '/': (context) => token == null ? LoginScreen() : HomeScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/home': (context) =>  HomeScreen(),
        '/reward': (context) =>  RewardScreen(),
        '/promotion': (context) =>  PromotionScreen(),
        '/point': (context) =>  Points(),
        '/login': (context) => LoginPage(),
        '/coin': (context) => Coin(),
      }
    );
  }
}

