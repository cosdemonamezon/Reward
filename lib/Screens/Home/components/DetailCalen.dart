import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DetailCalen extends StatefulWidget {
  DetailCalen({Key key}) : super(key: key);

  @override
  _DetailCalenState createState() => _DetailCalenState();
}

class _DetailCalenState extends State<DetailCalen> {
  CalendarController _controller;
  String template_kNavigationBarColor, template_kNavigationFooterBarColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text("Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            TableCalendar(
              initialCalendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
                formatButtonDecoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadiusDirectional.circular(20.0)),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
                formatButtonShowsNext: false,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color(0xff30384c),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color(0xff30384c),
                ),
              ),
              calendarStyle: CalendarStyle(
                holidayStyle: TextStyle(letterSpacing: 10),
                todayColor: Colors.orangeAccent,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarController: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
