import 'package:camera/camera.dart';
import 'package:face_net_authentication/cwyf/screens/checkin.classic.screen.dart';
import 'package:face_net_authentication/cwyf/screens/login.screen.dart';
import 'package:face_net_authentication/cwyf/services/auth.service.dart';
import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';

  const AccountScreen({ Key? key }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(50),
              child: ListTile(
                title: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset('assets/images/logo1.png', scale: 5),

                      SizedBox(height: 20),
                      ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUp(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                },
                child: ListTile(
                  title: Text('เพิ่มนักเรียน/นักศึกษา'),
                  trailing: Icon(Icons.add),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckinClassicScreen()),
                  );
                },
                child: ListTile(
                  title: Text('เช็คชื่อ'),
                  trailing: Icon(Icons.check),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                onTap: () {
                  AuthService().removeToken();
                  Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                },
                child: ListTile(
                  title: Text('ออกจากระบบ'),
                  trailing: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}