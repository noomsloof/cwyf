import 'dart:io';

import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/utilities/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth.service.dart';

class StudentService {
  final _storage = const FlutterSecureStorage();
  static const className = 'StudentService';
  final String baseUrl = '${Globals.API}';

  Future<http.Response> addStudent(StudentModel model) async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    return await http.post(Uri.parse('$baseUrl/student'),
        body: convert.jsonEncode(model), headers: headers);
  }

  Future<List<StudentModel>> findAll() async {
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$baseUrl/student'), headers: headers);
    return parseStudentFind(response.body);
  }

  List<StudentModel> parseStudentFind(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed
        .map<StudentModel>((json) => StudentModel.formJson(json))
        .toList();
  }

  Future<StudentModel> findOne(String code) async {
    print(code);
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response =
        await http.get(Uri.parse('$baseUrl/student/${code}'), headers: headers);
    return StudentModel.formJson(convert.jsonDecode(response.body));
  }
}
