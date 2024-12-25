import 'dart:convert';
import 'dart:io';
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseService {
  // singleton boilerplate
  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  DataBaseService._internal();

  /// file that stores the data on filesystem
  late File jsonFile;

  final StudentModel _student = StudentModel();

  /// Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  /// loads a simple json file.
  Future loadDB() async {
    var tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';

    jsonFile = new File(_embPath);

    if (jsonFile.existsSync()) {
      _db = json.decode(jsonFile.readAsStringSync());
    }
  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future saveData(String code, String name, List modelData) async {
    String userAndPass = code + ':' + name;
    _db[userAndPass] = modelData;
    jsonFile.writeAsStringSync(json.encode(_db));

    _student.code = code;
    _student.name = name;

    StudentService().addStudent(_student).then((res) {
        print(res.statusCode);
        if (res.statusCode == 201) {
          // Navigator.of(context).pushReplacementNamed(MenubarScreen.routeName);
          print('เพิ่มนักเรียนสำเร็จ');
        } else {
          print('เพิ่มข้อมูลใบหน้านักเรียนสำเร็จ');
        }
      }).catchError((error) {
        print(error);
        print('เพิ่มนักเรียนไม่สำเร็จ');
      });

  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    jsonFile.writeAsStringSync(json.encode({}));
  }
}
