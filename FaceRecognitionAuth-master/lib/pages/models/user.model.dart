import 'package:flutter/material.dart';

class User {
  String codestudent;
  String name;

  User({required this.codestudent, required this.name});

  static User fromDB(String dbuser) {
    return new User(codestudent: dbuser.split(':')[0], name: dbuser.split(':')[1]);
  }
}
