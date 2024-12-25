import 'dart:io';

import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/utilities/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth.service.dart';

class CheckNameService {
  final _storage = const FlutterSecureStorage();
  static const className = 'CheckNameService';
  final String baseUrl = '${Globals.API}';

  Future<http.Response> addCheckName(CheckNameModel model, String idstudent) async {
    print(model.date);
    print(model.status);
    print(model.idcheckname);
    print(idstudent);
    var headers = {HttpHeaders.authorizationHeader:'Bearer ${await AuthService().getToken()}',HttpHeaders.contentTypeHeader: 'application/json'};
    var data = model.toJson();
    data.remove("_id");
    return await http.post(Uri.parse('$baseUrl/check-name/${idstudent}/check-name/'),body: convert.jsonEncode(data), headers: headers);
  }

    Future<http.Response> addCheckNameFaceScan(CheckNameModel model, String idstudent) async {
    print(idstudent);
    var headers = {HttpHeaders.authorizationHeader:'Bearer ${await AuthService().getToken()}',HttpHeaders.contentTypeHeader: 'application/json'};
    var data = model.toJson();
    data.remove("_id");
    return await http.post(Uri.parse('$baseUrl/check-name/${idstudent}/check-name/'),body: convert.jsonEncode(data), headers: headers);
  }

  Future<List<CheckNameModel>> findAll(String idstudent) async {
    // print(idstudent);
    var headers = {
      HttpHeaders.authorizationHeader:
          'Bearer ${await AuthService().getToken()}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(Uri.parse('$baseUrl/check-name/${idstudent}/check-name'), headers: headers);
    return parseStudentFind(response.body);
  }

  List<CheckNameModel> parseStudentFind(String responseBody) {
    final parsed = convert.jsonDecode(responseBody)["data"].cast<Map<String, dynamic>>();
    return parsed.map<CheckNameModel>((json) => CheckNameModel.formJson(json)).toList();
  }

  //   Future<StudentModel> findOne(String code) async {
  //     print(code);
  //   var headers = {
  //     HttpHeaders.authorizationHeader:
  //         'Bearer ${await AuthService().getToken()}',
  //     HttpHeaders.contentTypeHeader: 'application/json'
  //   };
  //   var response = await http.get(Uri.parse('$baseUrl/student/${code}'), headers: headers);
  //   return StudentModel.formJson(convert.jsonDecode(response.body));
  // }

}
