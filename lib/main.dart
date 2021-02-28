import 'package:Reward/Promotion/PromotionScreen.dart';
import 'package:Reward/Reward/components/Detail_Reward.dart';
import 'package:Reward/Screens/Home/HomeScreen.dart';
import 'package:Reward/Screens/Home/components/Points.dart';
import 'package:Reward/Screens/Home/components/Profilesettings.dart';
import 'package:Reward/Screens/Home/components/Cradit.dart';
import 'package:Reward/Screens/Login/LoginScreen.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:Reward/Screens/Login/components/LoginPage.dart';
import 'Screens/Login/components/DetailNoti.dart';
import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Reward/Reward/RewardScreen.dart';
import 'package:flutter/services.dart';
import 'package:Reward/Screens/Home/components/StatusReward.dart';
import 'package:Reward/Screens/Home/components/TransferPoints.dart';

import 'Screens/Login/components/NotiScreen.dart';
import 'package:Reward/Award/AwardScreen.dart';
import 'package:Reward/Award/WebViewAward.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Screens/Login/components/PinCode.dart';
import 'Screens/Login/components/PinAuthen.dart';
import 'Screens/Home/components/LinkShare.dart';

String token;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  runApp(MyApp());

  OneSignal.shared.init("cc3885db-be23-4b3e-ab93-5c49b16e1a82", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
  });

  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
    navigatorKey.currentState
        .pushNamed(result.notification.payload.additionalData['/home']);
  });

  var status = await OneSignal.shared.getPermissionSubscriptionState();
  String playerId = status.subscriptionStatus.userId;
  print(playerId);
  // await OneSignal.shared.postNotification(OSCreateNotification(
  //   playerIds: [playerId],
  //   content: "this is a test from OneSignal's Flutter SDK",
  //   heading: "Test Notification",
  //   buttons: [
  //     OSActionButton(text: "test1", id: "id1"),

  //   ]
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MZ Reward',
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
          '/home': (context) => HomeScreen(),
          '/reward': (context) => RewardScreen(),
          '/promotion': (context) => PromotionScreen(),
          '/point': (context) => Points(),
          '/login': (context) => LoginPage(),
          '/coin': (context) => Coin(),
          '/detailreward': (context) => DetailReward(),
          '/profilesetting': (context) => Profilesettings(),
          '/status': (context) => StatusReward(),
          '/transfer': (context) => TransferPoints(),
          '/award': (context) => AwardScreen(),
          '/cradit': (context) => Cradit(),
          '/pincode': (context) => PinCode(),
          '/share': (context) => LinkShare(),
          '/noti': (context) => NotiScreen(),
          '/notidetail': (context) => DetailNoti(),
          '/help': (context) => Helpadvice(),
          '/webview': (context) => WebViewAward(),
          '/authenpincode': (context) => PinAuthen(),
        });
  }
}
