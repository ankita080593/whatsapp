import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
void showSnackBar({required BuildContext context,required String message}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar
    (backgroundColor:Colors.red,content: Text(message),
  ),
  );
}