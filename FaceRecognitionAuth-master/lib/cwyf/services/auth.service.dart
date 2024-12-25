
import 'dart:io';
import 'package:face_net_authentication/cwyf/models/user.model.dart';
import 'package:face_net_authentication/cwyf/utilities/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class AuthService{
  final _storage = const FlutterSecureStorage();
  static const className = 'AuthService';
  final String baseUrl = '${Globals.API}';

  Future<http.Response> login(UserModel model) async {
    const headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(Uri.parse('$baseUrl/auth/login'), body: convert.jsonEncode(model), headers: headers);
  }

  Future<http.Response> register(UserModel model) async {
    const headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    return await http.post(Uri.parse('$baseUrl/users'), body: convert.jsonEncode(model), headers: headers);
  }

  Future<String?> getRemember() async{
    return await _storage.read(key: 'remember');
  }

  void setRemember(String value){
    _storage.write(key: 'remember', value: value);
  }

  Future<String?> getToken() async{
    return await _storage.read(key: 'token');
  }

  void setToken(String value){
    _storage.write(key: 'token', value: value);
  }

  void removeToken(){
    _storage.deleteAll();
  }

  Map<String, dynamic> _parseJwt(String token){
    final parts = token.split('.');
    if( parts.length != 3 ){
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);

    final payloadMap = convert.jsonDecode(payload);
    if(payloadMap is! Map<String, dynamic>){
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str){
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4){
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string"');
    }
    return convert.utf8.decode(convert.base64Url.decode(output));
  }

  Future<dynamic> decodeToken() async{
    var token = await getToken();
    return _parseJwt(token ?? '');
  }

  Future<dynamic> decodeUserId() async{
    var token = await getToken();
    return _parseJwt(token ?? '')['user_id'];
  }
}