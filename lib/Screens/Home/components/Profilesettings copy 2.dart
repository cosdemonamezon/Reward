import 'package:Reward/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:Reward/Screens/Login/components/Coin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Reward/Screens/Login/components/Helpadvice.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profilesettings extends StatefulWidget {
  Profilesettings({Key key}) : super(key: key);

  @override
  _ProfilesettingsState createState() => _ProfilesettingsState();
}

class _ProfilesettingsState extends State<Profilesettings> {
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey1 = GlobalKey<FormBuilderState>();
  bool active = false;
  SharedPreferences prefs;
  bool isLoading = false;
  String username = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getActive();
    _getColor();
  }

  _getActive() {
    active = true;
    //initState();
  }

  _getColor() async {
    //print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var profile = prefs.getString('profile');
    var tokenprofile = convert.jsonDecode(profile);

    setState(() {
      username = tokenprofile['data']['username'];
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });
  }

  _getComfirmUsername(Map<String, dynamic> values) async {
    //print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);

    setState(() {
      template_kNavigationBarColor = token['color']['color_1'];
      template_kNavigationFooterBarColor = token['color']['color_2'];
    });

    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/getComfirmUsername_M';
    var response = await http.post(url,
        headers: {
          //'Content-Type':'application/json',
          'token': token['token']
        },
        body: ({
          'username': values['username'],
          'member_username_game': values['member_username_game'],
          'board_shot_name': values['board_shot_name'],
          'member_address': values['member_address'],
        }));
    if (response.statusCode == 200) {
      //var token = convert.jsonDecode(response.body);
      await prefs.setString('token', response.body);
      final Map<String, dynamic> comfirm = convert.jsonDecode(response.body);
      if (comfirm['code'] == "200") {
        //print(comfirm['massage']);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogHome(
            comfirm['massage'],
            picSuccess,
            context,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            comfirm['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      }
    } else {
      // var comfirm = convert.jsonDecode(response.body);
      // print(comfirm['massage']);
      // print(response.statusCode);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => errordialog(
          errorProfile,
          checkData,
          picDenied,
          context,
        ),
      );
    }
  }

  _editMember(Map<String, dynamic> values1) async {
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    //String s = values1['id'];
    //int id = int.parse(s);
    //print(values1);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/edit_Member';
    var response = await http.post(url,
        headers: {
          //'Content-Type':'application/json',
          'token': token['token']
        },
        body: ({
          'member_id': values1['id'],
          //'member_id': id,
          'member_name_th': values1['member_name_th'],
          'member_name_en': values1['member_name_en'],
          'member_email': values1['member_email'],
          'member_address': values1['member_address']
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> profile = convert.jsonDecode(response.body);
      if (profile['code'] == "200") {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      } else if (profile['code'] == "400") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            errorProfile,
            picDenied,
            context,
          ),
        );
      } else if (profile['code'] == "500") {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => errordialog(
            profile['massage'],
            checkData,
            picDenied,
            context,
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialogDenied(
            headtitle,
            picDenied,
            context,
          ),
        );
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialogDenied(
          headtitle,
          picDenied,
          context,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //print(data);
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Sign Up',
                // style: AppTextTheme.kBigTitle),
                style: Theme.of(context).textTheme.headline,
              ),
              Container(height: 16),
              Text(
                "Some text describing what happens when we do stuff with things and other stuff that probably won't fit in this layout and will give us the horrible error banner ath the bottom of the screen. There's scope for even more text depending on how I'm feeling this evening. It could be that I stop typing, it could be that I type more and more. It really depends on what ",
                // style: AppTextTheme.kParagraph),
                style: Theme.of(context).textTheme.body1,
              ),
              Container(height: 24),
              Text("Email address"),
              TextField(
                decoration: InputDecoration(hintText: "Email address"),
              ),
              Container(height: 8),
              Text("Password"),
              TextField(
                decoration: InputDecoration(hintText: "Password"),
              ),
              Container(height: 24),
              MaterialButton(
                onPressed: () {
                  // Do stuff
                },
                child: Text("Sign up"),
              ),
              Container(height: 32),
              FlatButton(
                child: Column(
                  children: [
                    Text(
                      "Already have an account ?",
                      // style: AppTextTheme.kParagraphBold,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Text("Sign in",
                        // style: AppTextTheme.kParagraphBold
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(decoration: TextDecoration.underline)),
                  ],
                ),
                onPressed: () {
                  // Navigator.pushReplacementNamed(
                  //     context, RoutePaths.SIGN_IN);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
