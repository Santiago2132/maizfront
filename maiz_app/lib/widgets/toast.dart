import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:provider/provider.dart';

void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 242, 176),
      textColor: Colors.white,
      fontSize: 20,
  );
}