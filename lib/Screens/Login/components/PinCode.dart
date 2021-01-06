import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatefulWidget {
  PinCode({Key key}) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  TextEditingController textEditingController = TextEditingController();
  final String requiredNumber = '12345';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFFFFFFF),
      backgroundColor: Color(0xff050f40),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pin Code"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: 30.0),
              Text(
                "Enter pin number",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(height: 30.0),
              PinCodeTextField(
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  appContext: context,
                  length: 5,
                  obscureText: true,
                  obscuringCharacter: '●',
                  onChanged: (value) {
                    print(value);
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    inactiveColor: Colors.red,
                    activeColor: Colors.red,
                    selectedColor: Colors.blue,
                  ),
                  backgroundColor: Color(0xff050f40),
                  enableActiveFill: false,
                  controller: textEditingController,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.white,
                      blurRadius: 1,
                    )
                  ],
                  onCompleted: (value) {
                    if (value == requiredNumber) {
                      Navigator.pushNamed(context, "/login");
                    } else {
                      textEditingController.clear();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
