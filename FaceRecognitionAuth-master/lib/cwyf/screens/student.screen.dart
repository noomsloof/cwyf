
import 'package:face_net_authentication/cwyf/screens/student.main.screen.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart';

class StudentScreen extends StatefulWidget {
  static const routeName = '/student';

  const StudentScreen({Key? key}) : super(key: key);

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();

  String ?code ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: _buildFormLogin(),
        ),
      ),
    ));
  }

  Widget _buildFormLogin() {
    return Column(
      children: [
        SizedBox(height: 50,),
        Image.asset('assets/images/logo1.png', scale: 8),
        SizedBox(height: 10,),
        Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "ดูข้อมูลการเช็คชื่อ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _codeInput(),
                        SizedBox(
                          height: 50,
                        ),
                        _loginButton(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _codeInput() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'รหัสนักศึกษา',
              prefixIcon: Icon(Icons.account_circle_outlined)),
          textAlign: TextAlign.start,
          controller: _codeController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรอกข้อมูล';
            }
            return null;
          },
          onSaved: (value) => code = value,
        ),
      ],
    );
  }

  Widget _loginButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onFindOne(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login),
                SizedBox(width: 10),
                Text(
                  'ตรวจสอบ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onFindOne() {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentMainScreen(code: code,)),
            );
      ToastClass().ShowToast(code.toString());
    }
  }
}
