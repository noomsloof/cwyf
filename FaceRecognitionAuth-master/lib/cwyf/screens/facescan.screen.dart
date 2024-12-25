// import 'package:cwyf/facescan/pages/home.dart';
import 'package:flutter/material.dart';

class FacescanScreen extends StatefulWidget {
  static const routeName = '/facescan';

  const FacescanScreen({ Key? key }) : super(key: key);

  @override
  _FacescanScreenState createState() => _FacescanScreenState();
}

class _FacescanScreenState extends State<FacescanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // MyHomePage(),
            ],
          ),
        ),
      ),
    );
  }
}