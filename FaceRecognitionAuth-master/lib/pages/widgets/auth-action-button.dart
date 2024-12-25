import 'dart:io';

import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/check-name.service.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:face_net_authentication/pages/profile.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();

  final TextEditingController _codeTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _nameTextEditingController =
      TextEditingController(text: '');

  User? predictedUser;

  final CheckNameModel _checkname = CheckNameModel();

  //เพิ่มนักเรียนตรงนี้
  Future _signUp(context) async {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    /// gets predicted data from facenet service (user face detected)
    List predictedData = _faceNetService.predictedData;
    String codestudent = _codeTextEditingController.text;
    String name = _nameTextEditingController.text;

    /// creates a new user in the 'database'
    await _dataBaseService.saveData(codestudent, name, predictedData);

    ToastClass().ShowToast('เพิ่มนักเรียนสำเร็จ');

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

  //กดเช็ค
  late List<StudentModel> studentList;
  late String idstudent;

  Future _signIn(context) async {
    
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    studentList = await StudentService().findAll();

    if (this.predictedUser!.codestudent.isNotEmpty) {
      _checkname.date = DateTime.now().toString().split(' ')[0];
      _checkname.status = 1;

      getAllstudent(predictedUser!.codestudent.toString());

      CheckNameService()
          .addCheckNameFaceScan(_checkname, idstudent)
          .then((res) {
        // print(res);
        print(res.statusCode);
        if (res.statusCode == 201) {
          ToastClass().ShowToast('${predictedUser!.name} มา');
        } else {
          ToastClass().ShowToast('บันทึกไม่สำเร็จ');
        }
      }).catchError((error) {
        print(error);
        ToastClass().ShowToast('บันทึกไม่สำเร็จ');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('ไม่พบนักศึกษาคนนี้ กรุณาเพิ่ม'),
          );
        },
      );
    }
  }

  String? _predictUser() {
    String? userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                this.predictedUser = User.fromDB(userAndPass);
              }
            }
            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));

            bottomSheetController.closed.whenComplete(() => widget.reload());
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF0F0BDB),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'จับภาพ',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

//เข้าระบบ
  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Container(
                  child: Column(
                    children: [
                      Text(
                        'รหัสนักศึกษา : ' + predictedUser!.codestudent,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        ' ชื่อ : ' + predictedUser!.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : widget.isLogin
                  ? Container(
                      child: Text(
                      'ไม่พบนักเรียน 😞',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          Container(
            child: Column(
              children: [
                !widget.isLogin
                    ? AppTextField(
                        controller: _codeTextEditingController,
                        labelText: "รหัสนักศึกษา",
                      )
                    : Container(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? Container()
                    : AppTextField(
                        controller: _nameTextEditingController,
                        labelText: "ชื่อนักศึกษา",
                      ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? AppButton(
                        text: 'เช็คชื่อ',
                        onPressed: () async {
                          //กดเช็ค
                          _signIn(context);
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'เพิ่มนักศึกษา',
                            onPressed: () async {
                              await _signUp(context);
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getAllstudent(String codestudent) {
    studentList
        .map((element) => {justOneStudent(element, codestudent)})
        .toList();
  }

  void justOneStudent(var data, String codestudent) {
    if (data.code == codestudent) {
      idstudent = data.idstudent;
    }
  }
}
