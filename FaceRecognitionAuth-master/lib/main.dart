import 'package:face_net_authentication/cwyf/screens/account.screen.dart';
import 'package:face_net_authentication/cwyf/screens/add.student.screen.dart';
import 'package:face_net_authentication/cwyf/screens/checkin.classic.checkin.screen.dart';
import 'package:face_net_authentication/cwyf/screens/checkin.classic.screen.dart';
import 'package:face_net_authentication/cwyf/screens/dashboard.screen.dart';
import 'package:face_net_authentication/cwyf/screens/facescan.screen.dart';
import 'package:face_net_authentication/cwyf/screens/login.screen.dart';
import 'package:face_net_authentication/cwyf/screens/menubar.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.term.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.week.data.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.week.screen.dart';
import 'package:face_net_authentication/cwyf/screens/select.role.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.main.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.report.term.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.report.week.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.screen.dart';
import 'package:face_net_authentication/pages/home.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectRoleScreen(),
        routes: {
        SelectRoleScreen.routeName: (context) => SelectRoleScreen(),
        StudentScreen.routeName: (context) => StudentScreen(),
        StudentMainScreen.routeName: (context) => StudentMainScreen(),
        StudentReportWeekScreen.routeName: (context) => StudentReportWeekScreen(),
        StudentReportTermScreen.routeName: (context) => StudentReportTermScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        MenubarScreen.routeName: (context) => MenubarScreen(),
        FacescanScreen.routeName: (context) => FacescanScreen(),
        ReportScreen.routeName: (context) => ReportScreen(),
        ReportTermScreen.routeName: (context) => ReportTermScreen(),
        ReportWeekScreen.routeName: (context) => ReportWeekScreen(),
        ReportWeekDataScreen.routeName: (context) => ReportWeekDataScreen(),
        AccountScreen.routeName: (context) => AccountScreen(),
        AddStudentScreen.routeName: (context) => AddStudentScreen(),
        CheckinClassicScreen.routeName: (context) => CheckinClassicScreen(),
        CheckinClassicCheckinScreen.routeName: (context) => CheckinClassicCheckinScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
      }
    );
  }
}
