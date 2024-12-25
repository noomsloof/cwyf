import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:face_net_authentication/cwyf/screens/account.screen.dart';
import 'package:face_net_authentication/cwyf/screens/dashboard.screen.dart';
import 'package:face_net_authentication/cwyf/screens/report.screen.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:face_net_authentication/pages/scanhome.dart';
import 'package:flutter/material.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class MenubarScreen extends StatefulWidget {
  static const routeName = '/menubar';

  const MenubarScreen({Key? key}) : super(key: key);

  @override
  _MenubarScreenState createState() => _MenubarScreenState();
}

class _MenubarScreenState extends State<MenubarScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    DashboardScreen(),
    scanhome(),
    ReportScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: ScrollController(), // Note the controller here
        title: Center(
          child: Text(
            "CHECK IN WITH YOUR FACE.",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.red[500],
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        selectedColor: Colors.red,
        unSelectedColor: Colors.black54,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        enableLineIndicator: true,
        lineIndicatorWidth: 3,
        indicatorType: IndicatorType.Top,
        customBottomBarItems: [
          CustomBottomBarItems(
            label: 'หน้าหลัก',
            icon: Icons.home,
          ),
          CustomBottomBarItems(
            label: 'สแกนใบหน้า',
            icon: Icons.face,
          ),
          CustomBottomBarItems(
            label: 'สรุป',
            icon: Icons.checklist,
          ),
          CustomBottomBarItems(
            label: 'ผู้ใช้งาน',
            icon: Icons.account_circle_outlined,
          ),
        ],
      ),
    );
  }
}
