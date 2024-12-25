
import 'package:camera/camera.dart';
import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class scanhome extends StatefulWidget {
  scanhome({Key? key}) : super(key: key);
  @override
  _scanhomeState createState() => _scanhomeState();
}

class _scanhomeState extends State<scanhome> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  late CameraDescription cameraDescription;
  bool loading = false;

  // String githubURL =
  //     "https://github.com/MCarlomagno/FaceRecognitionAuth/tree/master";

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.back,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  // void _launchURL() async => await canLaunch(githubURL)
  //     ? await launch(githubURL)
  //     : throw 'Could not launch $githubURL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    _dataBaseService.cleanDB();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cleaning_services_outlined, color: Colors.black),
                        Text('ล้างข้อมูลใบหน้า'),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        Card(
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  'วิธีการใช้งาน',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('การเช็คชื่อ :'),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('- กดปุ่ม '),
                                          Text(
                                            'เริ่มเช็คชื่อ',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.blue,
                                          ),
                                          Text(' เพื่อเริ่มสแกนหน้าเช็คชื่อ')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                              '- หากไม่พบใบหน้านักเรียน ให้ทำการเพิ่มนักเรียน ')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('  ก่อนเริ่มทำการเช็คชื่อ')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('การเพิ่มนักเรียน :'),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('- เข้าไปที่เมนู '),
                                          Column(
                                            children: [
                                              Icon(Icons
                                                  .account_circle_outlined),
                                              Text('ผู้ใช้งาน'),
                                            ],
                                          ),
                                          Icon(Icons.arrow_forward),
                                          Text(' เพิ่มนักเรียน/นักศึกษา'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('ล้างข้อมูลใบหน้า :'),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('- กดปุ่ม '),
                                          Icon(Icons.more_vert),
                                          Text(' ด้านขวาบน'),
                                          Icon(Icons.arrow_forward),
                                          Icon(
                                              Icons.cleaning_services_outlined),
                                          Text(' ล้างข้อมูลใบหน้า'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ),

                        //ตรงนี้ตรงเช็คชื่อ
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignIn(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เริ่มเช็คชื่อ',
                                  style: TextStyle(color: Color(0xFF0F0BDB)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.check, color: Color(0xFF0F0BDB))
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
