import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastClass{

  void ShowToast(String text) {
    FToast fToast;
    fToast = FToast();
    // fToast.init(context);

    fToast.showToast(
      child: _toastxt(text),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget _toastxt(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[850],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

}