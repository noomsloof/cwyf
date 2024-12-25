
import 'package:face_net_authentication/cwyf/screens/login.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.screen.dart';
import 'package:flutter/material.dart';

class SelectRoleScreen extends StatefulWidget {
  static const routeName = '/selectrole';

  const SelectRoleScreen({Key? key}) : super(key: key);

  @override
  _SelectRoleScreenState createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink[50],
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo1.png', scale: 5),
            SizedBox(height: 30,),
            _buildItemStudent(),
            _buildItemTeacher(),
          ],
        )),
      ),
    );
  }

  Widget _buildItemStudent() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
          splashColor: Colors.grey.withAlpha(30),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(StudentScreen.routeName);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: ListTile(
              title: Text('นักเรียน'),
              trailing: Icon(Icons.arrow_right),
            ),
          )),
    );
  }

  Widget _buildItemTeacher() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
          splashColor: Colors.grey.withAlpha(30),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: ListTile(
              title: Text('ครู'),
              trailing: Icon(Icons.arrow_right),
            ),
          )),
    );
  }
}
