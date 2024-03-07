import 'package:flutter/material.dart';
class Error404Screen extends StatelessWidget {
  final error;
  const Error404Screen({required this.error,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Image.asset('assets/images/img_5.png',fit: BoxFit.fill,),);
  }
}
