import 'package:face_net_authentication/cwyf/models/user.model.dart';
import 'package:face_net_authentication/cwyf/screens/menubar.screen.dart';
import 'package:face_net_authentication/cwyf/services/auth.service.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserModel _user = UserModel();

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
        SizedBox(height: 20,),
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
                      Text("เข้าสู่ระบบครู", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                      SizedBox(height: 30,),
                      _usernameInput(),
                      SizedBox(
                        height: 50,
                      ),
                      _passwordInput(),
                      SizedBox(
                        height: 50,
                      ),
                      _loginButton(),
                    ],
                  )),
            ],
          ),
          )
          
        ),
      ],
    );
  }

  Widget _usernameInput() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'USERNAME', prefixIcon: Icon(Icons.account_circle_outlined)),
          textAlign: TextAlign.start,
          controller: _usernameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรอกข้อมูล';
            }
            return null;
          },
          onSaved: (value) => _user.username = value,
        ),
      ],
    );
  }

  Widget _passwordInput() {
    return Column(children: [
      TextFormField(
        decoration: const InputDecoration(labelText: 'PASSWORD', prefixIcon: Icon(Icons.vpn_key_outlined)),
        obscureText: true,
        textAlign: TextAlign.start,
        controller: _passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรอกข้อมูล';
          }
          return null;
        },
        onSaved: (value) => _user.password = value,
      ),
    ]);
  }

  Widget _loginButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onLogin(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login),
                SizedBox(width: 10),
                Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onLogin() {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      AuthService().login(_user).then((res) {
        print(res.statusCode);
        if (res.statusCode == 200) {
          final response = convert.jsonDecode(res.body);
          AuthService().setToken(response['access_token']);
          AuthService().setRemember('true');
          Navigator.of(context).pushReplacementNamed(MenubarScreen.routeName);
          ToastClass().ShowToast('เข้าสู่ระบบสำเร็จ');
        } else {
          ToastClass().ShowToast('เข้าสู่ระบบไม่สำเร็จ');
        }
      }).catchError((error) {
        print(error);
        ToastClass().ShowToast('เข้าสู่ระบบไม่สำเร็จ');
      });
    }
  }
}
