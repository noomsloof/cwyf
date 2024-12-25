import 'package:face_net_authentication/cwyf/screens/report.term.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.week.screen.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = '/report';

  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const routeName = '/report';

  Widget page = ReportWeekScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: CircularMenu(
            alignment: Alignment.topLeft,
            toggleButtonBoxShadow: [
              BoxShadow(
                blurRadius: 0,
              ),
            ],
            toggleButtonSize: 30.0,
            backgroundWidget: Center(
              child: page,
            ),
            toggleButtonColor: Colors.red,
            items: [
              CircularMenuItem(
                  icon: Icons.calendar_today,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0,
                    ),
                  ],
                  color: Colors.red,
                  onTap: () {
                    setState(() {
                      page = ReportWeekScreen();
                    });
                  }),
              CircularMenuItem(
                  icon: Icons.pie_chart_rounded,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0,
                    ),
                  ],
                  color: Colors.red,
                  onTap: () {
                    setState(() {
                      page = ReportTermScreen();
                    });
                  })
            ],
          ),
        ));
  }
}
